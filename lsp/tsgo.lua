-- https://github.com/microsoft/typescript-go
-- Experimental Go port of tsc/tsserver. Install via `npm i -g @typescript/native-preview`
-- (or a project-local `npm i @typescript/native-preview`, picked up automatically below).

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'tsgo'
    local root_dir = (config or {}).root_dir
    if root_dir then
      local local_cmd = vim.fs.joinpath(root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, '--lsp', '--stdio' }, dispatchers)
  end,
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }, '.git' },
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = 'literals', suppressWhenArgumentMatchesName = true },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
}
