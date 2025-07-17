-- Performance: Defer filetype detection for faster startup (if not set elsewhere)
vim.loader.enable()
vim.g.mapleader = vim.keycode '<space>'
vim.g.maplocalleader = vim.keycode '<cr>'

-- remove netrw banner for cleaner looking
vim.g.netrw_banner = 0

vim.g.python3_host_prog = 'python3'
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
