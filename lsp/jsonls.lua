-- NOTE: vim.lsp.enable sources this file eagerly at startup, so only register
-- the plugin here (cheap, and keeps the unused-plugin check quiet); the schema
-- list is built lazily in before_init when a client actually starts
vim.pack.add { 'https://github.com/b0o/schemastore.nvim' }

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
      -- Must mutate config.settings in place: replacing the table breaks the
      -- reference the client already holds
      local settings = config.settings --[[@as table<string, table>]]
      settings.json.schemas = schemastore.json.schemas()
    end
  end,
  single_file_support = true,
}
