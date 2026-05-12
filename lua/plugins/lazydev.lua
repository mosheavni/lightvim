vim.pack.add { 'https://github.com/folke/lazydev.nvim' }
---@diagnostic disable-next-line: missing-fields
require('lazydev').setup { path = '${3rd}/luv/library', words = { 'vim%.uv' } }
