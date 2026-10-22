vim.pack.add { 'https://github.com/b0o/schemastore.nvim' }

---@type vim.lsp.Config
return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml' },
  root_markers = { '.git' },
  settings = {
    -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
    redhat = { telemetry = { enabled = false } },
    yaml = {
      -- Disable the server's own schema fetching; before_init provides the
      -- explicit SchemaStore list instead
      schemaStore = { enable = false, url = '' },
    },
  },
  before_init = function(_, config)
    local ok, schemastore = pcall(require, 'schemastore')
    if ok then
      -- Must mutate config.settings in place: replacing the table breaks the
      -- reference the client already holds
      local settings = config.settings --[[@as table<string, table>]]
      settings.yaml.schemas = schemastore.yaml.schemas()
    end
  end,
}
