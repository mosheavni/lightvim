vim.pack.add {
  { src = 'https://github.com/Ramilito/kubectl.nvim', version = vim.version.range '2.x' },
  'https://github.com/saghen/blink.download',
}

require("kubectl").setup({
  auto_refresh = { enabled = true, interval = 300 },
  lsp = { enabled = true },
})
vim.keymap.set(
  "n",
  "<leader>k",
  '<cmd>lua require("kubectl").toggle({ tab = true })<cr>',
  { noremap = true, silent = true }
)
