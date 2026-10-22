-- Performance: Defer filetype detection for faster startup (if not set elsewhere)
vim.loader.enable()
vim.g.mapleader = vim.keycode '<space>'
vim.g.maplocalleader = vim.keycode '<cr>'

-- don't load builtins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
