-- Native statusline (no plugin). Git branch/status come from gitsigns.nvim's
-- buffer-local vars (vim.b.gitsigns_head), which it keeps updated async, instead
-- of shelling out to `git` on every redraw.

local modes = {
  n = 'NORMAL',
  i = 'INSERT',
  v = 'VISUAL',
  V = 'V-LINE',
  ['\22'] = 'V-BLOCK',
  c = 'COMMAND',
  t = 'TERMINAL',
  R = 'REPLACE',
  s = 'SELECT',
  S = 'S-LINE',
  ['\19'] = 'S-BLOCK',
}

local function set_statusline_highlights()
  local pmenu_sel = vim.api.nvim_get_hl(0, { name = 'PmenuSel', link = false })
  local directory = vim.api.nvim_get_hl(0, { name = 'Directory', link = false })
  local visual = vim.api.nvim_get_hl(0, { name = 'Visual', link = false })
  vim.api.nvim_set_hl(0, 'StlMode', { fg = pmenu_sel.fg, bg = visual.bg })
  vim.api.nvim_set_hl(0, 'StlGit', { fg = directory.fg, bg = pmenu_sel.bg })
end
set_statusline_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Recompute statusline highlight groups after colorscheme change',
  callback = set_statusline_highlights,
})

function _G.lightvim_statusline()
  local mode = modes[vim.fn.mode()] or vim.fn.mode():upper()
  local branch = vim.b.gitsigns_head
  local status = vim.b.gitsigns_status
  local git = (branch and branch ~= '')
    and ('%#StlGit# ' .. branch .. (status and status ~= '' and ' ' .. status or '') .. ' %*')
    or ''

  -- Per-severity colored segments using the icons from vim.diagnostic.config signs
  local diag = vim.diagnostic.status()
  if diag ~= '' then
    diag = diag .. ' '
  end

  local clients = {}
  for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
    clients[#clients + 1] = client.name
  end
  local lsp = #clients > 0 and (table.concat(clients, ',') .. ' ') or ''

  return '%#StlMode# '
    .. mode
    .. ' %*'
    .. git
    .. ' %<%f%m%r'
    .. '%='
    .. diag
    .. lsp
    .. vim.bo.filetype
    .. ' %l:%c '
end

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  desc = 'Redraw statusline on diagnostic changes',
  callback = function()
    vim.cmd 'redrawstatus!'
  end,
})

vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
  desc = 'Redraw statusline when LSP clients (dis)connect',
  callback = function()
    vim.cmd 'redrawstatus!'
  end,
})

vim.o.statusline = '%!v:lua.lightvim_statusline()'
