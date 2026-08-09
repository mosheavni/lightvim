local function prettierd()
  return 'prettierd --stdin-filepath ' .. vim.fn.expand '%:p'
end

local function ruff_format()
  return 'ruff format --stdin-filename ' .. vim.fn.expand '%:p' .. ' -'
end

local formatprg_by_filetype = {
  css = prettierd,
  html = prettierd,
  javascript = prettierd,
  javascriptreact = prettierd,
  json = prettierd,
  jsonc = prettierd,
  less = prettierd,
  markdown = prettierd,
  scss = prettierd,
  typescript = prettierd,
  typescriptreact = prettierd,
  yaml = prettierd,
  groovy = 'npm-groovy-lint --format -',
  hcl = 'terragrunt hclfmt -',
  lua = 'stylua -',
  python = ruff_format,
  sh = 'shfmt -',
  zsh = 'shfmt -',
  terraform = 'terraform fmt -',
  toml = 'tombi fmt -',
  xml = 'xmllint --format -',
}

---@param formatprg string|fun():string
---@return string
local function resolve(formatprg)
  if type(formatprg) == 'function' then
    return formatprg()
  end
  return formatprg
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('UserFormatprg', { clear = true }),
  pattern = vim.tbl_keys(formatprg_by_filetype),
  desc = 'Set formatprg per filetype',
  callback = function(args)
    vim.bo[args.buf].formatprg = resolve(formatprg_by_filetype[args.match])
  end,
})
