---@type vim.lsp.Config
return {
  cmd = { 'vscode-json-languageserver', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { '.git' },
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
  single_file_support = true,
}
