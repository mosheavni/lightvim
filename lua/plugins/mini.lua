local url = 'https://github.com/nvim-mini/'

-- Startup: notify + statusline must be ready before first frame
vim.pack.add { url .. 'mini.notify', url .. 'mini.statusline' }

require('mini.notify').setup { lsp_progress = { enable = true } }
vim.keymap.set('n', '<leader>nh', function()
  require('mini.notify').show_history()
end, { silent = true, desc = 'Show notifications history' })
vim.keymap.set('n', '<leader>nx', function()
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
    url .. 'mini.icons',
    url .. 'mini.clue',
    url .. 'mini.cursorword',
  }

  require('mini.icons').setup()

  local pick = require 'mini.pick'
  pick.setup {}
  vim.keymap.set('n', '<leader>ff', pick.builtin.files, { silent = true, desc = 'Find files' })
  vim.keymap.set('n', '<leader>fb', pick.builtin.buffers, { silent = true, desc = 'Find open buffers' })
  vim.keymap.set('n', '<leader>fh', pick.builtin.help, { silent = true, desc = 'Find help tags' })
  vim.keymap.set('n', '<leader>fg', pick.builtin.grep_live, { silent = true, desc = 'Live grep' })

  require('mini.extra').setup {}
  vim.keymap.set('n', '<leader>o', '<cmd>Pick explorer<cr>', { desc = 'File explorer' })
  vim.keymap.set('n', '<F4>', '<cmd>Pick git_branches<cr>', { desc = 'Git branches' })
  vim.keymap.set('n', '<leader>fi', '<cmd>Pick oldfiles current_dir=true<cr>', { desc = 'Recent files' })
  vim.keymap.set('n', 'z=', '<cmd>Pick spellsuggest<cr>', { desc = 'Spell suggest' })

  require('mini.surround').setup {}
  vim.keymap.set('n', 'saa', 'sa_', { remap = true })

  local gen_spec = require('mini.ai').gen_spec
  require('mini.ai').setup {
    mappings = { around_next = 'aa', inside_next = 'ii' },
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

  require('mini.cursorword').setup {}

  local clue = require 'mini.clue'
  clue.setup {
    triggers = {
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'n', keys = '"' },
      { mode = 'n', keys = '<C-w>' },
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },
    clues = {
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
      { mode = 'n', keys = '<Leader>f',  desc = '+Picker' },
      { mode = 'n', keys = '<Leader>g',  desc = '+Git' },
      { mode = 'n', keys = '<Leader>c',  desc = '+Copy' },
      { mode = 'n', keys = '<Leader>cf', desc = '+Copy file' },
      { mode = 'n', keys = '<Leader>l',  desc = '+LSP' },
      { mode = 'n', keys = '<Leader>h',  desc = '+Hunks' },
      { mode = 'n', keys = '<Leader>d',  desc = '+Diff' },
      { mode = 'n', keys = '<Leader>n',  desc = '+Notifications' },
      { mode = 'n', keys = '<Leader>q',  desc = '+Quit' },
    },
  }
end)
