local fugitive_config = function()
  ---------------------
  -- Toggle fugitive --
  ---------------------
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
  end)

  ----------------------------
  -- Git cd to root of repo --
  ----------------------------
  vim.keymap.set('n', '<leader>gc', function()
    vim.cmd 'Gcd'
    local cwd = vim.fn.getcwd()
    vim.print('Changed directory to Git root' .. cwd)
  end)

  vim.keymap.set('n', '<leader>gb', function()
    local branch = vim.fn.FugitiveHead()
    -- Set the new line
    local current_line = vim.api.nvim_get_current_line()
    local new_line = current_line .. branch
    vim.api.nvim_set_current_line(new_line)
  end)
  vim.keymap.set('n', '<leader>gB', function()
    local branch = vim.fn.FugitiveHead()
    vim.fn.setreg('+', branch)
    vim.notify('Copied current branch "' .. branch .. '" to clipboard.')
  end)
end
---@type PluginSpec
return {
  src = 'https://github.com/tpope/vim-fugitive',
  data = {
    config = fugitive_config,
    ---@type PluginKeys[]
    keys = {
      { 'n', '<leader>gg', 'Toggle Git status' },
      { 'n', '<leader>gc', 'CD to Git root directory' },
      { 'n', '<leader>gb', 'Add the branch name to the buffer' },
      { 'n', '<leader>gB', 'Copy the branch name to clipboard' },
    }
  }
}
