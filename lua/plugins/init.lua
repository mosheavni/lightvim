local packs = require 'core.packs'

---@type (PluginSpec|PluginSpec[])[]
local plugins = {
  require 'plugins.lazydev',
  require 'plugins.mini',
  require 'plugins.treesitter',
  require 'plugins.color',
  -- Add more plugins here or create separate files
  -- Each file can return:
  --   - Single plugin: ---@type PluginSpec
  --   - Multiple plugins: ---@type PluginSpec[]
}

packs.lazy_load(plugins)
packs.setup_cleanup(plugins)
