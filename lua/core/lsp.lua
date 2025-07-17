-- :h lsp-config

-- enable lsp completion
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
  callback = function(args)
    vim.lsp.set_log_level 'trace'
    require('vim.lsp.log').set_format_func(vim.inspect)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method 'textDocument/implementation' then
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {
        buffer = args.buf,
        desc = 'Go to implementation',
      })
    end

    require 'core.completion'(client, args.buf)

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if
      not client:supports_method 'textDocument/willSaveWaitUntil' and client:supports_method 'textDocument/formatting'
    then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('BufFmt', { clear = true }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format { bufnr = args.buf, id = client.id, timeout_ms = 1000 }
        end,
      })
    end
  end,

  -- diagnostic
  vim.diagnostic.config {
    virtual_lines = {
      current_line = true,
    },
  },
})

-- enable configured language servers
-- you can find server configurations from lsp/*.lua files
vim.lsp.enable 'gopls'
vim.lsp.enable 'lua_ls'
vim.lsp.enable 'ts_ls'
vim.lsp.enable 'yaml_ls'
