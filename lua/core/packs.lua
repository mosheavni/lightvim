vim.pack.add {
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/echasnovski/mini.surround',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}
require('mini.surround').setup {
  mappings = {
    add = 'ys',
    delete = 'ds',
    find = '',
    find_left = '',
    highlight = '',
    replace = 'cs',
    update_n_lines = '',

    -- Add this only if you don't want to use extended mappings
    suffix_last = '',
    suffix_next = '',
  },
  search_method = 'cover_or_next',
}
require('lualine').setup {
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = {
      {
        function()
          local clients = vim.lsp.get_clients { bufnr = 0 }
          if not next(clients) then
            return 'No Active Lsp'
          end
          return 'LSP: '
            .. table.concat(
              vim.tbl_map(function(client)
                return client.name
              end, clients),
              ', '
            )
        end,
        icon = { ' ' },
      },
      'fileformat',
      'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
}
---@diagnostic disable-next-line: missing-fields
require('lazydev').setup { path = '${3rd}/luv/library', words = { 'vim%.uv' } }

-- treesitter
local configs = require 'nvim-treesitter.configs'
---@diagnostic disable: missing-fields
configs.setup {
  highlight = { enable = true },
  ensure_installed = {
    'bash',
    'comment',
    'diff',
    'embedded_template',
    'javascript',
    'json',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'regex',
    'terraform',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'xml',
    'yaml',
  },
  matchup = { enable = true },
  indent = { enable = true, disable = { 'yaml' } },
}
-- }}}

-- fzf {{{
require('fzf-lua').setup {
  opts = {
    'default-title',
    files = { git_icons = true },
    oldfiles = { cwd_only = true, include_current_session = true },
    grep = { hidden = true },
    keymap = { fzf = { ['ctrl-q'] = 'select-all+accept' } },
  },
}
vim.keymap.set('n', '<C-p>', ':FzfLua files<cr>', { desc = 'FzfLua files' })
vim.keymap.set('n', '<C-b>', ':FzfLua buffers<cr>', { desc = 'FzfLua buffers' })
vim.keymap.set('n', '<leader>hh', ':FzfLua help_tags<cr>', { desc = 'FzfLua help tags' })
vim.keymap.set('n', '<leader>i', ':FzfLua oldfiles<cr>', { desc = 'FzfLua old files' })
vim.keymap.set('n', '<leader>/', function()
  require('fzf-lua').live_grep {
    multiprocess = true,
    rg_opts = [=[--column --line-number --hidden --no-heading --color=always --smart-case --max-columns=4096 -g '!.git' -e]=],
  }
end, { desc = 'FzfLua live grep' })
-- }}}
