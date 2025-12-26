vim.schedule(function()
  vim.keymap.set('n', 'gp', '<cmd>execute "Git push -u origin " . FugitiveHead()<CR>',
    { desc = "Git push", silent = true, remap = false, buffer = 0 })
  vim.keymap.set('n', 'gl', '<cmd>Git pull<CR>', { desc = "Git pull", silent = true, remap = false, buffer = 0 })
  vim.keymap.set('n', 'gl', '<cmd>Git fetch --all --tags<CR>',
    { desc = "Git fetch all remote and tags", silent = true, remap = false, buffer = 0 })
end)
