---For replacing certain <C-x>... keymaps.
---@param keys string
local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end

---Is the completion menu open?
local function pumvisible()
  return tonumber(vim.fn.pumvisible()) ~= 0
end

return function(client, bufnr)
  -- If the client doesn't support completion, return.
  if not client:supports_method 'textDocument/completion' then
    return
  end

  -- Enable completion and configure keybindings.
  vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

  -- Use enter to accept completions.
  vim.keymap.set('i', '<cr>', function()
    return pumvisible() and '<C-y>' or '<cr>'
  end, { expr = true })

  -- Use slash to dismiss the completion menu.
  vim.keymap.set('i', '/', function()
    return pumvisible() and '<C-e>' or '/'
  end, { expr = true })

  -- Use <C-n> to navigate to the next completion or:
  -- - Trigger LSP completion.
  -- - If there's no one, fallback to vanilla omnifunc.
  vim.keymap.set('i', '<C-n>', function()
    if pumvisible() then
      feedkeys '<C-n>'
    else
      if next(vim.lsp.get_clients { bufnr = 0 }) then
        vim.lsp.completion.get()
      else
        if vim.bo.omnifunc == '' then
          feedkeys '<C-x><C-n>'
        else
          feedkeys '<C-x><C-o>'
        end
      end
    end
  end, { desc = 'Trigger/select next completion' })

  -- Buffer completions.
  vim.keymap.set('i', '<C-u>', '<C-x><C-n>', { desc = 'Buffer completions' })

  -- Use <Tab> to accept a suggestion, navigate between snippet tabstops,
  -- or select the next completion.
  -- Do something similar with <S-Tab>.
  vim.keymap.set({ 'i', 's' }, '<Tab>', function()
    if pumvisible() then
      feedkeys '<C-n>'
    elseif vim.snippet.active { direction = 1 } then
      vim.snippet.jump(1)
    else
      feedkeys '<Tab>'
    end
  end, {})
  vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
    if pumvisible() then
      feedkeys '<C-p>'
    elseif vim.snippet.active { direction = -1 } then
      vim.snippet.jump(-1)
    else
      feedkeys '<S-Tab>'
    end
  end, {})

  -- Inside a snippet, use backspace to remove the placeholder.
  vim.keymap.set('s', '<BS>', '<C-o>s', {})
end
