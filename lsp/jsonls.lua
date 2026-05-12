---@type vim.lsp.Config
return {
  cmd = { 'vscode-json-languageserver', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { '.git' },
  settings = {
    json = {
      validate = { enable = true },
    },
  },
  on_new_config = function(config)
    local ok, schemastore = pcall(require, 'schemastore')
    if ok then
      config.settings.json.schemas = schemastore.json.schemas()
    end
  end,
  single_file_support = true,
}
