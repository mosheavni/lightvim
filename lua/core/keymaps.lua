local map = vim.keymap.set

-- Search
map('n', '<CR>', '<Esc>:nohlsearch<CR><CR>', { remap = false, silent = true, desc = 'Clear search highlighting' })

-- Navigation
map({ 'n', 'v' }, '0', '^', { remap = false, desc = 'Go to the first non-blank character' })
-- Move view left or right
map('n', 'L', '5zl', { remap = false, desc = 'Move view to the right' })
map('v', 'L', '$', { remap = false, desc = 'Move view to the right' })
map('n', 'H', '5zh', { remap = false, desc = 'Move view to the left' })
map('v', 'H', '0', { remap = false, desc = 'Move view to the left' })

-- Scrolling centralized
map('n', '<C-u>', '<C-u>zz', { remap = false, desc = 'Scroll half page up and center' })
map('n', '<C-d>', '<C-d>zz', { remap = false, desc = 'Scroll half page down and center' })

-- Visual Mode
-- indent/unindent visual mode selection with tab/shift+tab
map('v', '<tab>', '>gv', { desc = 'Indent selected text' })
map('v', '<s-tab>', '<gv', { desc = 'Unindent selected text' })

-- Windows
map('n', '<c-w>v', ':vnew<cr>', { remap = false, silent = true, desc = 'New buffer vertically split' })
map('n', '<c-w>s', ':new<cr>', { remap = false, silent = true, desc = 'New buffer horizontally split' })
map('n', '<c-w>e', ':enew<cr>', { remap = false, silent = true, desc = 'New empty buffer' })
map('n', '<Left>', '<C-w>h', { remap = true, desc = 'Go to Left Window' })
map('n', '<Down>', '<C-w>j', { remap = true, desc = 'Go to Lower Window' })
map('n', '<Up>', '<C-w>k', { remap = true, desc = 'Go to Upper Window' })
map('n', '<Right>', '<C-w>l', { remap = true, desc = 'Go to Right Window' })

-- Quickfix
map('n', ']q', ':cnext<cr>zz', { remap = false, silent = true, desc = 'Next quickfix item' })
map('n', '[q', ':cprev<cr>zz', { remap = false, silent = true, desc = 'Previous quickfix item' })

-- Terminal
map('t', '<Esc>', [[<C-\><C-n>]], { remap = false, desc = 'Exit terminal mode' })

-- File Operations
-- Copy file path to clipboard
map(
  'n',
  '<leader>cfp',
  [[:let @+ = expand('%')<cr>:echo "Copied relative file path " . expand('%')<cr>]],
  { remap = false, silent = true, desc = 'Copy relative file path' }
)
map(
  'n',
  '<leader>cfa',
  [[:let @+ = expand('%:p')<cr>:echo "Copied full file path " . expand('%:p')<cr>]],
  { remap = false, silent = true, desc = 'Copy absolute file path' }
)
map(
  'n',
  '<leader>cfd',
  [[:let @+ = expand('%:p:h')<cr>:echo "Copied file directory path " . expand('%:p:h')<cr>]],
  { remap = false, silent = true, desc = 'Copy file directory path' }
)
map(
  'n',
  '<leader>cfn',
  [[:let @+ = expand('%:t')<cr>:echo "Copied file directory path " . expand('%:t')<cr>]],
  { remap = false, silent = true, desc = 'Copy file name' }
)

-- Change working directory based on open file
map(
  'n',
  '<leader>cd',
  ':cd %:p:h<CR>:pwd<CR>',
  { remap = false, silent = true, desc = 'Change directory to current file' }
)

-- Copy and Paste
-- Copy and paste to/from system clipboard
map('v', 'cp', '"+y', { desc = 'Copy to system clipboard' })
map('n', 'cP', '"+yy', { desc = 'Copy line to system clipboard' })
map('n', 'cp', '"+y', { desc = 'Copy to system clipboard' })
map('n', 'cv', '"+p', { desc = 'Paste from system clipboard' })
map('n', '<C-c>', 'ciw', { desc = 'Change inner word' })
-- Copy entire file to clipboard
map('n', 'Y', ':%y+<cr>', { remap = false, silent = true, desc = 'Copy buffer content to clipboard' })

-- Application
map('n', '<leader>qq', ':qall<cr>', { remap = false, silent = true, desc = 'Quit all' })

-- Diff
vim.api.nvim_create_user_command('DiffWithSaved', function()
  -- Get start buffer
  local start = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_get_option_value('filetype', { buf = start })
  vim.cmd 'vnew | set buftype=nofile | read ++edit # | 0d_ | diffthis'
  local scratch = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_option_value('filetype', filetype, { buf = scratch })
  vim.cmd 'wincmd p | diffthis'

  -- Map `q` for both buffers to exit diff view and delete scratch buffer
  for _, buf in ipairs { scratch, start } do
    map('n', 'q', function()
      vim.cmd 'windo diffoff'
      vim.api.nvim_buf_delete(scratch, { force = true })
      vim.keymap.del('n', 'q', { buffer = start })
    end, { buffer = buf })
  end
end, {})

map('n', '<leader>ds', ':DiffWithSaved<cr>', { remap = false, silent = true, desc = 'Diff with saved version' })

