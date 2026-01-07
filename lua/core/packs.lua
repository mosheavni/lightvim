---@class PluginKeys
---@field [1] string Mode (e.g., 'n', 'v', 'i')
---@field [2] string Left-hand side of the mapping
---@field [3]? string Description
---@field desc? string Description (alternative to [3])
---@field opts? table Additional keymap options

---@class PluginData
---@field event? string|string[] Event(s) to trigger lazy loading
---@field ft? string|string[] Filetype(s) to trigger lazy loading
---@field cmd? string|string[] Command(s) to trigger lazy loading
---@field keys? PluginKeys|PluginKeys[] Keymap(s) to trigger lazy loading
---@field pattern? string|string[] Pattern for event autocmd
---@field config? fun(plugin: table) Configuration function
---@field build? string|string[]|fun() Build command(s) to run after install/update

---@class PluginSpec
---@field src string Git URL of the plugin
---@field name? string Plugin name (defaults to repo name)
---@field version? string Git tag/branch/commit
---@field data? PluginData Lazy loading and configuration options

---Extract plugin name from spec
local function get_plugin_name(plugin)
  return plugin.name or plugin.src:match '[^/]+$'
end

---Clean up plugins that are installed but not in config
---@param configured_plugins PluginSpec[] The flattened list of configured plugins
local function cleanup_orphaned_plugins(configured_plugins)
  -- Build set of configured plugin names
  local configured = {}
  for _, plugin in ipairs(configured_plugins) do
    local name = type(plugin) == 'string' and plugin or get_plugin_name(plugin)
    configured[name] = true
  end

  -- Get all plugins managed by vim.pack
  local all_plugins = vim.pack.get(nil, { info = false })
  local orphaned = {}

  for _, plugin in ipairs(all_plugins) do
    local name = plugin.spec.name
    if not configured[name] then
      table.insert(orphaned, { name = name, path = plugin.path })
    end
  end

  if #orphaned == 0 then
    vim.notify('No orphaned plugins found', vim.log.levels.INFO)
    return
  end

  -- Show orphaned plugins
  local lines = { 'Orphaned plugins:' }
  for i, plugin in ipairs(orphaned) do
    table.insert(lines, string.format('%d. %s (%s)', i, plugin.name, plugin.path))
  end
  table.insert(lines, '\nRemove all? [y/N]: ')

  local response = vim.fn.input(table.concat(lines, '\n'))
  if response:lower() == 'y' then
    local names = vim.tbl_map(function(p)
      return p.name
    end, orphaned)
    vim.pack.del(names)
    vim.notify('Removed ' .. #names .. ' plugin(s)', vim.log.levels.INFO)
  end
end

local group = vim.api.nvim_create_augroup('LazyPlugins', { clear = true })

-- Track plugin loading state to prevent race conditions
local loading = {}
local loaded = {}

-- Store build commands for plugins
local build_commands = {}

---Execute a build command (function, string, or array)
local function execute_build(name, build)
  if type(build) == 'function' then
    local ok, err = pcall(build)
    local level = ok and vim.log.levels.INFO or vim.log.levels.ERROR
    local msg = ok and 'Build completed for ' or 'Build failed for '
    vim.notify(msg .. name .. (err and ': ' .. err or ''), level)
  elseif type(build) == 'string' then
    vim.notify('Running build for ' .. name .. ': ' .. build, vim.log.levels.INFO)
    vim.cmd(build)
  elseif type(build) == 'table' then
    for _, cmd in ipairs(build) do
      if type(cmd) == 'function' then
        cmd()
      else
        vim.cmd(cmd)
      end
    end
    vim.notify('Build completed for ' .. name, vim.log.levels.INFO)
  end
end

-- Set up PackChanged autocmd to run build commands
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local build = build_commands[name]

    -- Only run build on install or update
    if not build or (ev.data.kind ~= 'install' and ev.data.kind ~= 'update') then
      return
    end

    -- Ensure plugin is loaded if build needs it
    if not ev.data.active then
      vim.cmd.packadd(name)
    end

    execute_build(name, build)
  end,
})

---Convert string or table to table
local function ensure_table(val)
  return type(val) == 'table' and val or { val }
end

---Load a plugin and run its config
---@param plugin table Plugin object from vim.pack
---@param trigger_fn? function Optional function to call after loading (e.g., re-execute command)
local function load_plugin(plugin, trigger_fn)
  local name = plugin.spec.name

  -- Prevent duplicate loading
  if loading[name] or loaded[name] then
    return
  end

  loading[name] = true

  -- Load the plugin
  vim.cmd.packadd(name)
  loaded[name] = true
  loading[name] = false

  -- Run config if provided
  local data = plugin.spec.data or {}
  if data.config then
    local ok, err = pcall(data.config, plugin)
    if not ok then
      vim.notify('Error configuring ' .. name .. ': ' .. err, vim.log.levels.ERROR)
    end
  end

  -- Execute trigger function after plugin is loaded
  if trigger_fn then
    vim.schedule(trigger_fn)
  end
end

---Flatten nested plugin tables
---@param plugins (PluginSpec|PluginSpec[])[]
---@return PluginSpec[]
local function flatten_plugins(plugins)
  local result = {}
  for _, plugin in ipairs(plugins) do
    -- Check if this is a nested table of plugins (no 'src' or 'name' field)
    if type(plugin) == 'table' and not plugin.src and not plugin.name then
      -- It's a nested table, flatten it
      for _, nested_plugin in ipairs(plugin) do
        table.insert(result, nested_plugin)
      end
    else
      -- It's a regular plugin spec
      table.insert(result, plugin)
    end
  end
  return result
end

---Lazy load plugins with optional triggers
---@param plugins (PluginSpec|PluginSpec[])[]
local function lazy_load(plugins)
  plugins = flatten_plugins(plugins)

  _G.vim_plugins = vim.tbl_extend('force', _G.vim_plugins or {}, plugins)

  -- Store build commands for PackChanged autocmd
  for _, plugin in ipairs(plugins) do
    local data = type(plugin) == 'table' and plugin.data or nil
    if data and data.build then
      build_commands[get_plugin_name(plugin)] = data.build
    end
  end

  vim.pack.add(plugins, {
    load = function(plugin)
      local data = plugin.spec.data or {}

      -- Event trigger
      if data.event then
        vim.api.nvim_create_autocmd(ensure_table(data.event), {
          group = group,
          once = true,
          pattern = data.pattern,
          callback = function()
            load_plugin(plugin)
          end,
        })
      end

      -- Filetype trigger
      if data.ft then
        vim.api.nvim_create_autocmd('FileType', {
          group = group,
          pattern = ensure_table(data.ft),
          once = true,
          callback = function()
            load_plugin(plugin)
          end,
        })
      end

      -- Command trigger - supports single command or array of commands
      if data.cmd then
        for _, cmd in ipairs(ensure_table(data.cmd)) do
          vim.api.nvim_create_user_command(cmd, function(cmd_args)
            pcall(vim.api.nvim_del_user_command, cmd)
            load_plugin(plugin, function()
              -- Re-execute the command after plugin loads
              local cmd_str = cmd
              if #cmd_args.fargs > 0 then
                cmd_str = cmd_str .. ' ' .. table.concat(cmd_args.fargs, ' ')
              end
              if cmd_args.bang then
                cmd_str = cmd_str .. '!'
              end
              vim.cmd(cmd_str)
            end)
          end, {
            nargs = '*',
            range = true,
            bang = true,
            complete = data.complete,
          })
        end
      end

      -- Keymap trigger - supports single keymap or array of keymaps
      -- Format: { mode, lhs, desc?, opts? } or {{ mode, lhs, desc?, opts? }, ...}
      if data.keys then
        -- Detect if it's a single keymap (first element is mode string) or array of keymaps
        local keys_list = type(data.keys[1]) == 'string' and { data.keys } or data.keys
        for _, key_spec in ipairs(keys_list) do
          local mode, lhs = key_spec[1], key_spec[2]
          local desc = key_spec[3] or key_spec.desc
          local opts = vim.tbl_extend('force', { desc = desc }, key_spec.opts or {})

          vim.keymap.set(mode, lhs, function()
            vim.keymap.del(mode, lhs)
            load_plugin(plugin, function()
              -- Re-trigger the keymap after plugin loads
              local keys = vim.api.nvim_replace_termcodes(lhs, true, false, true)
              vim.api.nvim_feedkeys(keys, 'mt', false)
            end)
          end, opts)
        end
      end

      -- If no lazy loading triggers are specified, load immediately
      if not data.event and not data.ft and not data.cmd and not data.keys then
        load_plugin(plugin)
      end
    end,
  })
end

vim.api.nvim_create_user_command('PackClean', function()
  cleanup_orphaned_plugins(_G.vim_plugins)
end, { desc = 'Clean up orphaned plugins' })

-- Module exports
local M = {}

M.lazy_load = lazy_load

return M
