local url_pref = 'https://github.com/nvim-mini/'
return {
  {
    src = url_pref .. 'mini.indentscope',
    data = {
      event = 'BufReadPost',
      config = function()
        vim.api.nvim_create_autocmd('FileType', {
          pattern = {
            'dashboard',
            'floaterm',
            'fugitive',
            'help',
            'lazy',
            'lazyterm',
            'mason',
            'notify',
            'trouble',
            'Trouble',
            'input',
          },
          callback = function()
            vim.b.miniindentscope_disable = true
          end,
        })

        vim.api.nvim_create_autocmd('TermOpen', {
          callback = function()
            vim.b.miniindentscope_disable = true
          end,
        })

        require('mini.indentscope').setup {
          symbol = '│',
          options = { try_as_border = true },
        }
        vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#76D1A3' })
      end,
    },
  },
  {
    src = url_pref .. 'mini.surround',
    data = {
      config = function()
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
      end,
    },
  },
}
