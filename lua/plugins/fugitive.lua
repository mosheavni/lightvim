vim.pack.add { 'https://github.com/tpope/vim-fugitive' }

vim.keymap.set('n', '<leader>gg', function()
  local to_close = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'fugitive' then
      to_close[#to_close + 1] = win
    end
  end
  if #to_close > 0 then
    for _, win in ipairs(to_close) do
      if vim.api.nvim_win_is_valid(win) then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
    return
  end
  vim.cmd 'Git'
end, { desc = 'Toggle Git status' })

vim.keymap.set('n', '<leader>gc', function()
  vim.cmd 'Gcd'
  vim.print('Changed directory to Git root: ' .. vim.fn.getcwd())
end, { desc = 'CD to Git root' })

vim.keymap.set('n', '<leader>gb', function()
  local branch = vim.fn.FugitiveHead()
  local line = vim.api.nvim_get_current_line()
  vim.api.nvim_set_current_line(line .. branch)
end, { desc = 'Add branch name to buffer' })

vim.keymap.set('n', '<leader>gB', function()
  local branch = vim.fn.FugitiveHead()
  vim.fn.setreg('+', branch)
  vim.notify('Copied branch "' .. branch .. '" to clipboard')
end, { desc = 'Copy branch name to clipboard' })
