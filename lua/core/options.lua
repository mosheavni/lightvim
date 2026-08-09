-- Display & UI
vim.o.title = true
vim.o.cursorcolumn = true
vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 2  -- Narrow number column
vim.o.signcolumn = 'yes'
vim.o.showmode = false -- Redundant, the statusline shows the mode
vim.o.cmdheight = 1
vim.o.laststatus = 3
vim.o.showcmd = true
vim.o.showmatch = true
vim.o.matchtime = 2        -- How long to show matching bracket
vim.o.winborder = 'rounded'
vim.o.wrap = false         -- Don't wrap lines
vim.o.conceallevel = 0     -- Don't hide markup
vim.o.concealcursor = ''   -- Don't hide cursor line markup
vim.o.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.shortmess:append { c = true, l = false, q = false, S = false, C = true, I = true }
vim.opt.pumblend = 10      -- Popup menu transparency
vim.opt.winblend = 0       -- Floating window transparency
vim.opt.fillchars = {
  vert = '│',
  fold = ' ',
  foldopen = '',
  foldclose = '',
  foldsep = ' ',
  foldinner = ' ',
  diff = ' ',
  eob = ' ',
}

-- Search
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.inccommand = 'split'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.grepprg = 'rg --vimgrep --smart-case --hidden'
vim.opt.grepformat = '%f:%l:%c:%m'

-- Scrolling
vim.o.scrolloff = 4
vim.o.sidescrolloff = 8

-- Split Behavior
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.splitkeep = 'screen' -- Prevent text from shifting when opening/closing splits
vim.o.equalalways = true

-- Completion
vim.o.autocomplete = true
vim.o.complete = 'o,.,w,b,u'
vim.o.completeopt = 'menu,menuone,noselect,noinsert,popup,fuzzy' -- modern completion menu
vim.o.pumheight = 10                                             -- max height of completion menu

-- Folding
vim.o.foldenable = true   -- enable fold
vim.o.foldlevel = 99      -- start editing with all folds opened
vim.o.foldlevelstart = 99 -- open all folds when opening a buffer
vim.o.foldcolumn = '1'    -- show fold indicator column
vim.o.foldtext = ''       -- use the first folded line with syntax highlighting
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

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
vim.o.list = true     -- use special characters to represent things like tabs or trailing spaces
vim.opt.listchars = { -- NOTE: using `vim.opt` instead of `vim.o` to pass rich object
  tab = '▏ ',
  trail = '·',
  extends = '»',
  precedes = '«',
}

-- File & Buffer Management
vim.o.autoread = true
vim.o.autowrite = false   -- Don't auto save
vim.o.hidden = true
vim.o.backup = false      -- Don't create backup files
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
vim.opt.synmaxcol = 300
vim.o.updatetime = 300
vim.o.timeoutlen = 400 -- Faster key sequence completion (default is 1000ms)

-- Command & Wildmenu
vim.o.wildmenu = true
vim.opt.wildmode = { 'noselect' }
vim.opt.wildoptions:append { 'fuzzy', 'pum' } -- Enable fuzzy matching and popup menu
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
vim.o.errorbells = false             -- No error bells
vim.o.backspace = 'indent,eol,start' -- Better backspace behavior
vim.o.autochdir = false              -- Don't auto change directory
vim.opt.iskeyword:append '-'         -- Treat dash as part of word
vim.o.selection = 'exclusive'        -- Selection behavior
vim.o.virtualedit = 'block'          -- Allow cursor to move freely in visual block mode
vim.o.encoding = 'UTF-8'             -- Set encoding
vim.o.jumpoptions = 'stack'          -- Treat the jumplist like a stack
vim.opt.nrformats:append 'blank'     -- <C-a>/<C-x> on blank-separated numbers

-- Diff Options
vim.opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'indent-heuristic',
  'linematch:60',
  'vertical',
  'algorithm:histogram',
  'inline:char',
  'context:6',
  'iwhite',
}

-- Filetype Detection
local kube_config_pattern = [[.*\.kube/config]]
vim.filetype.add {
  extension = { tfvars = 'terraform' },
  filename = {
    Brewfile = 'ruby',
    ['docker-compose.yml'] = 'yaml.docker-compose',
  },
  pattern = {
    ['.*/templates/.*%.yaml'] = {
      function(_, bufnr)
        for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
          if line:find '{{.+}}' then
            return 'helm'
          end
        end
      end,
      { priority = 200 },
    },
    ['.*/.github/workflows/.*%.yml'] = 'yaml.ghaction',
    ['.*Jenkinsfile.*'] = 'groovy',
    [kube_config_pattern] = 'yaml',
    ['.*'] = {
      function(_, bufnr)
        -- k8s manifests without a .yaml extension: kind:/apiVersion: in the first 20 lines
        for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 20, false)) do
          if line:match '^kind:' or line:match '^apiVersion:' then
            return 'yaml'
          end
        end
      end,
      -- catch-all must lose to every specific pattern (:h vim.filetype.add)
      { priority = -math.huge },
    },
  },
}
