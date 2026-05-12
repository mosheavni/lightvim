-- Build hook must be registered before any vim.pack.add() call
-- so it fires on initial install (from lockfile) as well
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
    end
  end,
})

-- Startup: colorscheme + notify + statusline must render before first frame
require 'plugins.color'
require 'plugins.mini'

-- Deferred: everything else loads after first frame
vim.schedule(function()
  require 'plugins.treesitter'
  require 'plugins.lazydev'
  require 'plugins.fugitive'
  require 'plugins.gitsigns'
  vim.pack.add { 'https://github.com/b0o/schemastore.nvim' }
end)
