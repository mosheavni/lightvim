-- :h lsp-config
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  -- Also used by vim.diagnostic.status() in the statusline
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
    },
  },
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_lines = { current_line = true, overflow = 'wrap' },
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
    end,
  },
}

-- enable lsp completion
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- LSP keymaps (<leader>l...)
    vim.keymap.set('n', '<leader>lq', function()
      vim.diagnostic.setqflist()
      vim.cmd 'copen'
    end, { buffer = args.buf, desc = 'Diagnostics to quickfix' })

    require 'core.completion' (client, args.buf)

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if client:supports_method 'textDocument/formatting' then
      if not client:supports_method 'textDocument/willSaveWaitUntil' then
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = vim.api.nvim_create_augroup('BufFmt_' .. args.buf, { clear = true }),
          buffer = args.buf,
          callback = function()
            vim.lsp.buf.format { bufnr = args.buf, id = client.id, timeout_ms = 1000 }
          end,
        })
      end
      vim.keymap.set('n', '<leader>lp', function()
        vim.lsp.buf.format { bufnr = args.buf, id = client.id, timeout_ms = 1000 }
      end, {
        buffer = args.buf,
        desc = 'Format buffer with LSP',
      })
    else
      -- Fallback to formatprg if LSP doesn't support formatting
      local formatprg = vim.bo[args.buf].formatprg
      if formatprg ~= '' then
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = vim.api.nvim_create_augroup('BufFmtPrg_' .. args.buf, { clear = true }),
          buffer = args.buf,
          callback = function()
            local view = vim.fn.winsaveview()
            vim.cmd 'silent! normal! gggqG'
            vim.fn.winrestview(view)
          end,
        })
        vim.keymap.set('n', '<leader>lp', function()
          local view = vim.fn.winsaveview()
          vim.cmd 'silent! normal! gggqG'
          vim.fn.winrestview(view)
        end, { buffer = args.buf, desc = 'Format buffer with formatprg' })
      end
    end

    -- LSP document highlight: semantically highlight all references under cursor
    if client:supports_method('textDocument/documentHighlight', args.buf) then
      local hl_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = args.buf,
        group = hl_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = args.buf,
        group = hl_group,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(e)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = e.buf }
        end,
      })
    end
  end,
})

-- enable configured language servers
-- you can find server configurations from lsp/*.lua files
-- servers without a local lsp/*.lua rely on nvim-lspconfig defaults
vim.lsp.enable {
  'bashls',
  'cssls',
  'dockerls',
  'html',
  'jsonls',
  'lua_ls',
  'marksman',
  'pyright',
  'terraformls',
  'tsgo',
  'yaml_ls',
}
