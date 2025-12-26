---@type PluginSpec
return {
  src = 'https://github.com/lewis6991/gitsigns.nvim',
  data = {
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local gitsigns = require 'gitsigns'

      gitsigns.setup {
        on_attach = function(bufnr)
          local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal { ']c', bang = true }
            else
              gitsigns.nav_hunk 'next'
            end
          end, { desc = 'Next hunk' })

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal { '[c', bang = true }
            else
              gitsigns.nav_hunk 'prev'
            end
          end, { desc = 'Previous hunk' })

          map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
          map('n', '<leader>hb', function()
            gitsigns.blame_line { full = true }
          end, { desc = 'Blame line' })
        end,
      }
    end,
  },
}
