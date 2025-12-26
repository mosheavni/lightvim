vim.schedule(function()
  vim.keymap.set('n', 'gp', '<cmd>Git push<CR>', { desc = "Git push", silent = true, remap = false, buffer = 0 })
  vim.keymap.set('n', 'gl', '<cmd>Git pull<CR>', { desc = "Git pull", silent = true, remap = false, buffer = 0 })
end)
