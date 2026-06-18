-- Build hook must be registered before any vim.pack.add() call
-- so it fires on initial install (from lockfile) as well
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    end
  end,
})

require 'plugins.mini'
require 'plugins.lazydev'

vim.schedule(function()
  require 'plugins.treesitter'
  require 'plugins.fugitive'
  require 'plugins.gitsigns'
  require 'plugins.kubectl'
  vim.pack.add { 'https://github.com/b0o/schemastore.nvim' }
end)
