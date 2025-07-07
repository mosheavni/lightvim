-- Performance: Defer filetype detection for faster startup (if not set elsewhere)
vim.loader.enable()
vim.cmd [[colorscheme sorbet]]
vim.g.mapleader = ' '

-- general options
vim.o.completeopt = 'menu,menuone,noselect,popup,fuzzy' -- modern completion menu

vim.o.foldenable = true -- enable fold
vim.o.foldlevel = 99 -- start editing with all folds opened
vim.o.foldmethod = 'expr' -- use tree-sitter for folding method
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldtext = 'substitute(getline(v:foldstart),"\t",repeat(" ",&tabstop),"g")."...".trim(getline(v:foldend))'

vim.o.title = true
vim.o.cursorcolumn = true
vim.o.cursorline = true
vim.opt.shortmess:append { c = true, l = false, q = false, S = false, C = true, I = true }
vim.o.list = true
vim.o.shada = [[!,'1000,s10000,h]]
vim.o.number = true
vim.o.relativenumber = true
vim.o.linebreak = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.inccommand = 'split'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.autoread = true
vim.o.scrolloff = 4
vim.o.sidescrolloff = 8
vim.o.cmdheight = 1
vim.o.hidden = true
vim.o.showmatch = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.startofline = false
vim.o.confirm = true
vim.o.lazyredraw = false
vim.o.swapfile = false
vim.o.wildmenu = true
vim.opt.wildmode = { 'longest:full', 'full' }
vim.o.previewheight = 15
vim.o.laststatus = 3
vim.o.showcmd = true
vim.o.mouse = 'a'
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.textwidth = 80
vim.opt.cpoptions:append '>'
vim.o.equalalways = true
vim.o.history = 10000
vim.o.signcolumn = 'yes'
vim.o.updatetime = 300
vim.opt.wildignore:append { '**/node_modules/**', '.hg', '.git', '.svn', '*.DS_Store', '*.pyc' }
vim.opt.path:append { '**' }
vim.opt.formatoptions:append {
  c = true,
  j = true,
  l = true,
  o = true,
  r = true,
  t = true,
}
-- Indenting
vim.o.breakindent = true
vim.o.autoindent = true
vim.o.copyindent = true
vim.o.smartindent = true
vim.o.shiftwidth = 0
vim.o.shiftround = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.smarttab = true
vim.o.expandtab = true
vim.opt.indentkeys:remove '0#'
vim.opt.indentkeys:remove '<:>'

vim.o.pumheight = 10 -- max height of completion menu

vim.o.list = true -- use special characters to represent things like tabs or trailing spaces
vim.opt.listchars = { -- NOTE: using `vim.opt` instead of `vim.o` to pass rich object
  tab = '▏ ',
  trail = '·',
  extends = '»',
  precedes = '«',
}

vim.opt.diffopt:append 'linematch:60' -- second stage diff to align lines

vim.g.mapleader = vim.keycode '<space>'
vim.g.maplocalleader = vim.keycode '<cr>'

-- remove netrw banner for cleaner looking
vim.g.netrw_banner = 0

-- UI/UX: Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank { timeout = 200 }
  end,
  desc = 'Highlight selection on yank',
})

-- Jump to last edit position when reopening file
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = 'Return to last edit pos after reopen',
})
