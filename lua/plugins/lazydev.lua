vim.pack.add { 'https://github.com/folke/lazydev.nvim' }
---@diagnostic disable-next-line: missing-fields
require('lazydev').setup {
  integrations = { lspconfig = false },
  library = {
    { path = 'wezterm-types',           mods = { 'wezterm' } },
    { path = 'plenary.nvim',            words = { 'describe', 'assert' } },
    { path = '${3rd}/luv/library',      words = { 'vim%.uv' } },
    { path = '${3rd}/busted/library',   words = { 'describe', 'it', 'assert' } },
    { path = '${3rd}/luassert/library', words = { 'assert' } },
  },
}
