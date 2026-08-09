local group = vim.api.nvim_create_augroup('UserAutocmds', { clear = true })

-- UI/UX: Highlight on yank and paste
vim.api.nvim_create_autocmd({ 'TextYankPost', 'TextPutPost' }, {
  group = group,
  callback = function()
    vim.hl.hl_op { timeout = 200 }
  end,
  desc = 'Highlight selection on yank/paste',
})

-- Jump to last edit position when reopening file
vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = 'Return to last edit pos after reopen',
})

vim.api.nvim_create_autocmd('CmdlineChanged', {
  group = group,
  pattern = ':',
  callback = function()
    vim.fn.wildtrigger()
  end,
})

-- better yank ring
vim.api.nvim_create_autocmd('TextYankPost', { -- yank-ring
  desc = 'Maintain a yank ring in registers 0-9',
  group = group,
  callback = function()
    if vim.v.event.operator == 'y' then
      for i = 9, 1, -1 do -- Shift all numbered registers.
        vim.fn.setreg(tostring(i), vim.fn.getreg(tostring(i - 1)))
      end
    end
  end,
})

-- Make file executable when a shebang is detected
vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  desc = 'Make sh file executable if a shebang is detected',
  pattern = '*',
  callback = function(args)
    local shebang = vim.api.nvim_buf_get_lines(args.buf, 0, 1, true)[1]
    if not shebang or not shebang:match '^#!.+' then
      return
    end
    local filename = vim.api.nvim_buf_get_name(args.buf)
    if filename == '' then
      return
    end
    local fileinfo = vim.uv.fs_stat(filename)
    if not fileinfo or vim.uv.fs_access(filename, 'X') then
      return
    end
    -- selene: allow(undefined_variable)
    if vim.uv.fs_chmod(filename, bit.bor(fileinfo.mode, 493)) then
      vim.notify 'File made executable'
    end
  end,
})

-- Reload the file when it changed outside of Neovim
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = group,
  desc = 'Check if the file changed when regaining focus',
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd 'checktime'
    end
  end,
})
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = group,
  desc = 'Reload when the file is changed outside of Neovim',
  callback = function()
    vim.notify('File changed, reloading the buffer', vim.log.levels.WARN)
  end,
})

-- Spell checking for prose filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = { 'markdown', 'gitcommit', 'text' },
  desc = 'Enable spell checking for prose filetypes',
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { 'en' }
    vim.api.nvim_set_hl(0, 'SpellBad', {
      undercurl = true,
      sp = '#ff5555',
    })
  end,
})

-- Quit with q in these filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  desc = 'Quit with q in these filetypes',
  pattern = {
    'checkhealth',
    'help',
    'man',
    'notify',
    'qf',
    'lspinfo',
    'startuptime',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})
