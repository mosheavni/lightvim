vim.pack.add {
  'https://github.com/ibhagwan/fzf-lua',
  -- 'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/echasnovski/mini.surround',
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

---@diagnostic disable-next-line: missing-fields
require('lazydev').setup { path = '${3rd}/luv/library', words = { 'vim%.uv' } }
