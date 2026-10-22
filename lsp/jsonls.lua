---@type vim.lsp.Config
return {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { '.git' },
  settings = {
    json = {
      validate = { enable = true },
    },
  },
  before_init = function(_, config)
    local ok, schemastore = pcall(require, 'schemastore')
    if ok then
      config.settings.json.schemas = schemastore.json.schemas()
    end
  end,
  single_file_support = true,
}
