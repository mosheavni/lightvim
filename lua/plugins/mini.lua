local url = 'https://github.com/nvim-mini/'

-- Startup: notify + statusline must be ready before first frame
vim.pack.add { url .. 'mini.notify', url .. 'mini.statusline' }

require('mini.notify').setup { lsp_progress = { enable = false } }
vim.keymap.set('n', '<leader>n', function()
  require('mini.notify').show_history()
end, { silent = true, desc = 'Show notifications history' })
vim.keymap.set('n', '<leader>x', function()
  require('mini.notify').clear()
end, { silent = true, desc = 'Dismiss all notifications' })

require('mini.statusline').setup {}

-- Deferred: everything else loads after first frame
vim.schedule(function()
  vim.pack.add {
    url .. 'mini.pick',
    url .. 'mini.extra',
    url .. 'mini.surround',
    url .. 'mini.ai',
    url .. 'mini.pairs',
    url .. 'mini.operators',
    url .. 'mini.splitjoin',
    url .. 'mini.indentscope',
  }

  local pick = require 'mini.pick'
  pick.setup {}
  vim.keymap.set('n', '<leader>ff', pick.builtin.files, { silent = true, desc = 'Pick from list' })
  vim.keymap.set('n', '<leader>fb', pick.builtin.buffers, { silent = true, desc = 'Pick from buffers' })
  vim.keymap.set('n', '<leader>fh', pick.builtin.help, { silent = true, desc = 'Pick from help tags' })
  vim.keymap.set('n', '<leader>fg', pick.builtin.grep_live, { silent = true, desc = 'Pick from live grep' })

  require('mini.extra').setup {}
  vim.keymap.set('n', '<leader>o', '<cmd>Pick explorer<cr>', { desc = 'File explorer' })
  vim.keymap.set('n', '<F4>', '<cmd>Pick git_branches<cr>', { desc = 'Git branches' })
  vim.keymap.set('n', '<leader>fi', '<cmd>Pick oldfiles current_dir=true<cr>', { desc = 'Recent files' })
  vim.keymap.set('n', 'z=', '<cmd>Pick spellsuggest<cr>', { desc = 'Spell suggest' })

  require('mini.surround').setup {}
  vim.keymap.set('n', 'saa', 'sa_', { remap = true })

  local gen_spec = require('mini.ai').gen_spec
  require('mini.ai').setup {
    custom_textobjects = {
      F = gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
      c = gen_spec.treesitter { a = '@comment.outer', i = '@comment.inner' },
    },
  }

  require('mini.pairs').setup {
    mappings = {
      ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\`].', register = { cr = false } },
    },
  }

  require('mini.operators').setup { exchange = { prefix = '' } }
  require('mini.splitjoin').setup {}

  require('mini.indentscope').setup {
    symbol = '│',
    options = { try_as_border = true },
  }
  vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#76D1A3' })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'dashboard', 'floaterm', 'fugitive', 'help', 'lazy', 'lazyterm', 'mason', 'notify', 'trouble', 'Trouble', 'input' },
    callback = function()
      vim.b.miniindentscope_disable = true
    end,
  })
  vim.api.nvim_create_autocmd('TermOpen', {
    callback = function()
      vim.b.miniindentscope_disable = true
    end,
  })
end)
