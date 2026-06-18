local M = {}

-- LSP servers (see lsp/*.lua + core/lsp.lua)
local lsp_servers = {
  { name = 'bashls', binary = 'bash-language-server', install = 'npm install -g bash-language-server' },
  { name = 'cssls', binary = 'vscode-css-language-server', install = 'npm install -g vscode-langservers-extracted' },
  { name = 'dockerls', binary = 'docker-langserver', install = 'npm install -g dockerfile-language-server-nodejs' },
  { name = 'html', binary = 'vscode-html-language-server', install = 'npm install -g vscode-langservers-extracted' },
  { name = 'jsonls', binary = 'vscode-json-languageserver', install = 'npm install -g vscode-json-languageserver' },
  { name = 'lua_ls', binary = 'lua-language-server', install = 'brew install lua-language-server' },
  { name = 'marksman', binary = 'marksman', install = 'brew install marksman' },
  { name = 'pyright', binary = 'pyright-langserver', install = 'npm install -g pyright' },
  { name = 'terraformls', binary = 'terraform-ls', install = 'brew install hashicorp/tap/terraform-ls' },
  { name = 'ts_ls', binary = 'typescript-language-server', install = 'npm install -g typescript-language-server' },
  { name = 'yaml_ls', binary = 'yaml-language-server', install = 'npm install -g yaml-language-server' },
}

-- Formatters used via 'formatprg' (see ftplugin/*.lua)
local formatters = {
  { name = 'prettierd', binary = 'prettierd', install = 'npm install -g @fsouza/prettierd' },
  { name = 'npm-groovy-lint', binary = 'npm-groovy-lint', install = 'npm install -g npm-groovy-lint' },
  { name = 'ruff', binary = 'ruff', install = 'brew install ruff' },
  { name = 'shfmt', binary = 'shfmt', install = 'brew install shfmt' },
  { name = 'stylua', binary = 'stylua', install = 'brew install stylua' },
  { name = 'terraform', binary = 'terraform', install = 'brew install hashicorp/tap/terraform' },
  { name = 'terragrunt', binary = 'terragrunt', install = 'brew install terragrunt' },
  { name = 'tombi', binary = 'tombi', install = 'brew install tombi' },
  { name = 'xmllint', binary = 'xmllint', install = 'brew install libxml2' },
}

-- Other CLIs used by plugins
local tools = {
  { name = 'git', binary = 'git', install = 'brew install git' },
  { name = 'ripgrep', binary = 'rg', install = 'brew install ripgrep' },
  { name = 'kubectl', binary = 'kubectl', install = 'brew install kubectl' },
}

local function check_group(title, entries)
  vim.health.start(title)
  for _, tool in ipairs(entries) do
    if vim.fn.executable(tool.binary) == 1 then
      vim.health.ok(tool.name .. ' (' .. tool.binary .. ')')
    else
      vim.health.warn(tool.name .. ' (' .. tool.binary .. ') not found', { tool.install })
    end
  end
end

M.check = function()
  check_group('LSP servers', lsp_servers)
  check_group('Formatters', formatters)
  check_group('Tools', tools)
end

return M
