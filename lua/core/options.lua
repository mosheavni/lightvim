-- Colorscheme
vim.cmd [[colorscheme default]]

-- Display & UI
vim.o.title = true
vim.o.cursorcolumn = true
vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.cmdheight = 1
vim.o.laststatus = 3
vim.o.showcmd = true
vim.o.showmatch = true
vim.o.matchtime = 2 -- How long to show matching bracket
vim.o.winborder = 'rounded'
vim.o.wrap = false -- Don't wrap lines
vim.o.conceallevel = 0 -- Don't hide markup
vim.o.concealcursor = '' -- Don't hide cursor line markup
vim.opt.shortmess:append { c = true, l = false, q = false, S = false, C = true, I = true }
vim.opt.pumblend = 10 -- Popup menu transparency
vim.opt.winblend = 0 -- Floating window transparency

-- Search
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.inccommand = 'split'
vim.o.ignorecase = true
vim.o.smartcase = true

-- Scrolling
vim.o.scrolloff = 4
vim.o.sidescrolloff = 8

-- Split Behavior
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.equalalways = true

-- Completion
vim.o.autocomplete = true
vim.o.complete = 'o,.,w,b,u'
vim.o.completeopt = 'menu,menuone,noselect,noinsert,popup,fuzzy' -- modern completion menu
vim.o.pumheight = 10 -- max height of completion menu

-- Folding
vim.o.foldenable = true -- enable fold
vim.o.foldlevel = 99 -- start editing with all folds opened
vim.o.foldmethod = 'manual' -- use tree-sitter for folding method

-- Indentation
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

-- List Characters
vim.o.list = true -- use special characters to represent things like tabs or trailing spaces
vim.opt.listchars = { -- NOTE: using `vim.opt` instead of `vim.o` to pass rich object
  tab = '▏ ',
  trail = '·',
  extends = '»',
  precedes = '«',
}

-- File & Buffer Management
vim.o.autoread = true
vim.o.autowrite = false -- Don't auto save
vim.o.hidden = true
vim.o.backup = false -- Don't create backup files
vim.o.writebackup = false -- Don't create backup before writing
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath 'state' .. '/undo' -- Undo directory
vim.o.undolevels = 10000
vim.o.shada = [[!,'1000,s10000,h]]
vim.opt.path:append { '**' }

-- Create undo directory if it doesn't exist
local undodir = vim.fn.stdpath 'state' .. '/undo'
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p')
end

-- Performance
vim.o.lazyredraw = true
vim.opt.synmaxcol = 300
vim.o.updatetime = 300

-- Command & Wildmenu
vim.o.wildmenu = true
vim.opt.wildmode = { 'longest:full', 'full', 'noselect' }
vim.opt.wildignore:append { '**/node_modules/**', '.hg', '.git', '.svn', '*.DS_Store', '*.pyc' }
vim.o.previewheight = 15
vim.o.history = 10000

-- Text Editing
vim.o.linebreak = true
vim.o.startofline = false
vim.o.confirm = true
vim.o.textwidth = 80
vim.opt.cpoptions:append '>'
vim.opt.formatoptions:append {
  c = true,
  j = true,
  l = true,
  o = true,
  r = true,
  t = true,
}

-- Input
vim.o.mouse = 'a'

-- Behavior
vim.o.errorbells = false -- No error bells
vim.o.backspace = 'indent,eol,start' -- Better backspace behavior
vim.o.autochdir = false -- Don't auto change directory
vim.opt.iskeyword:append '-' -- Treat dash as part of word
vim.o.selection = 'exclusive' -- Selection behavior
vim.o.encoding = 'UTF-8' -- Set encoding

-- Diff Options
vim.opt.diffopt:append 'linematch:60' -- second stage diff to align lines
