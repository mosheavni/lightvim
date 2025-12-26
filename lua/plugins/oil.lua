---@type PluginSpec
return {
  src = 'https://github.com/stevearc/oil.nvim',
  data = {
    cmd = { 'Oil' },
    keys = {
      { 'n', '<leader>o', 'Open Oil' },
    },
    config = function()
      require('oil').setup({
        float = {
          get_win_title = nil,
          max_width = 0.6,
          max_height = 0.7,
          preview_split = 'right',
        },
        view_options = {
          show_hidden = true,
        },
      })
      vim.keymap.set('n', '<leader>o', "<cmd>lua require('oil').open_float()<cr>")
    end
  }
}
