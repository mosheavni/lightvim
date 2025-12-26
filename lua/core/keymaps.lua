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

-- Center screen when jumping
map('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
map('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })

-- EasyMotion
map({ 'n', 'x' }, 's', function()
  require('core.easymotion').easy_motion()
end, { desc = 'Jump to 2 characters' })

-- Visual Mode
-- indent/unindent visual mode selection with tab/shift+tab
map('v', '<tab>', '>gv', { desc = 'Indent selected text' })
map('v', '<s-tab>', '<gv', { desc = 'Unindent selected text' })

-- Indent block
vim.cmd [[
function! g:__align_based_on_indent(_)
  normal! v%koj$>
endfunction
]]
map('n', '<leader>gt', function()
  vim.go.operatorfunc = '__align_based_on_indent'
  return 'g@l'
end, { expr = true })

-- Windows
map('n', '<c-w>v', ':vnew<cr>', { remap = false, silent = true, desc = 'New buffer vertically split' })
map('n', '<c-w>s', ':new<cr>', { remap = false, silent = true, desc = 'New buffer horizontally split' })
map('n', '<c-w>e', ':enew<cr>', { remap = false, silent = true, desc = 'New empty buffer' })
map('n', '<C-h>', '<C-w>h', { remap = true, desc = 'Go to Left Window' })
map('n', '<C-j>', '<C-w>j', { remap = true, desc = 'Go to Lower Window' })
map('n', '<C-k>', '<C-w>k', { remap = true, desc = 'Go to Upper Window' })
map('n', '<C-l>', '<C-w>l', { remap = true, desc = 'Go to Right Window' })

-- Resize Windows
map('n', '<C-Up>', ':resize +2<CR>', { desc = 'Increase window height' })
map('n', '<C-Down>', ':resize -2<CR>', { desc = 'Decrease window height' })
map('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width' })
map('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width' })

-- Quickfix
map('n', ']q', ':cnext<cr>zz', { remap = false, silent = true, desc = 'Next quickfix item' })
map('n', '[q', ':cprev<cr>zz', { remap = false, silent = true, desc = 'Previous quickfix item' })

-- Terminal
map('t', '<Esc>', [[<C-\><C-n>]], { remap = false, desc = 'Exit terminal mode' })

-- File Operations
map('n', '<leader>cfp', function()
  local rel_path = vim.fn.expand '%'
  vim.fn.setreg('+', rel_path)
  print('Copied relative file path ' .. rel_path)
end, { remap = false, silent = true, desc = 'Copy relative file path' })
map('n', '<leader>cfa', function()
  local file_path = vim.fn.expand '%:p'
  vim.fn.setreg('+', file_path)
  print('Copied full file path  ' .. file_path)
end, { remap = false, silent = true, desc = 'Copy absolute file path' })
map('n', '<leader>cfd', function()
  local dir_path = vim.fn.expand '%:p:h'
  vim.fn.setreg('+', dir_path)
  print('Copied file directory path ' .. dir_path)
end, { remap = false, silent = true, desc = 'Copy file directory path' })
map('n', '<leader>cfn', function()
  local file_name = vim.fn.expand '%:t'
  vim.fn.setreg('+', file_name)
  print('Copied file name ' .. file_name)
end, { remap = false, silent = true, desc = 'Copy file name' })

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

vim.cmd('source ' .. vim.fn.stdpath 'config' .. '/lua/core/search-replace.vim')
