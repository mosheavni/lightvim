---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  root_markers = { {
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
  }, '.git' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        library = { vim.env.VIMRUNTIME .. '/lua' },
        checkThirdParty = false,
      },
      completion = { callSnippet = 'Replace' },
      hint = { enable = true },
    },
  },
}
