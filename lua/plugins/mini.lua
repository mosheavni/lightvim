local url_pref = 'https://github.com/nvim-mini/'

---@type PluginSpec[]
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
        require('mini.surround').setup {}
        vim.keymap.set('n', 'saa', 'sa_', { remap = true })
      end,
    },
  },
  {
    src = url_pref .. 'mini.notify',
    data = {
      config = function()
        require('mini.notify').setup {
          lsp_progress = { enable = false },
        }
        vim.keymap.set('n', '<leader>n', function()
          require('mini.notify').show_history()
        end, { silent = true, desc = 'Show notifications history' })
        vim.keymap.set('n', '<leader>x', function()
          require('mini.notify').clear()
        end, { silent = true, desc = 'Dismiss all notifications' })
      end,
    },
  },
  {
    src = url_pref .. 'mini.splitjoin',
    data = {
      keys = { 'n', 'gS' },
      config = function()
        require('mini.splitjoin').setup {}
      end,
    },
  },
  {
    src = url_pref .. 'mini.ai',
    data = {
      event = 'BufReadPost',
      config = function()
        local gen_spec = require('mini.ai').gen_spec
        require('mini.ai').setup {
          custom_textobjects = {
            -- Function definition (needs treesitter queries with these captures)
            F = gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
            c = gen_spec.treesitter { a = '@comment.outer', i = '@comment.inner' },
          },
        }
      end,
    },
  },
  {
    src = url_pref .. 'mini.pairs',
    data = {
      event = 'InsertEnter',
      config = function()
        require('mini.pairs').setup {
          mappings = {
            ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\`].', register = { cr = false } },
          },
        }
      end,
    },
  },
  {
    src = url_pref .. 'mini.operators',
    data = {
      event = 'BufReadPost',
      config = function()
        require('mini.operators').setup {}
      end,
    },
  },
  {
    src = url_pref .. 'mini.pick',
    data = {
      -- keys = {
      -- }
      config = function()
        local pick = require 'mini.pick'
        pick.setup {}

        vim.keymap.set('n', '<leader>ff', function()
          pick.builtin.files()
        end, { silent = true, desc = 'Pick from list' })
        vim.keymap.set('n', '<leader>fb', function()
          pick.builtin.buffers()
        end, { silent = true, desc = 'Pick from buffers' })
        vim.keymap.set('n', '<leader>fh', function()
          pick.builtin.help()
        end, { silent = true, desc = 'Pick from help tags' })
        -- builtin grep_live
        vim.keymap.set('n', '<leader>fg', function()
          pick.builtin.grep_live()
        end, { silent = true, desc = 'Pick from live grep' })
      end,
    },
  },
}
