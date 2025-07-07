---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  root_markers = { 'selene.toml', '.git' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      completion = { callSnippet = 'Replace' },
      hint = { enable = true },
    },
  },
}
