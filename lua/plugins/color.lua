---@type PluginSpec
return {
  src = 'https://github.com/rose-pine/neovim',
  name = 'rose-pine',
  data = {
    config = function()
      require('rose-pine').setup({
        variant = 'moon', -- auto, main, moon, dawn
        styles = {
          bold = true,
          italic = true,
          transparency = true,
        },
        highlight_groups = {
          StatusLine = { fg = 'love', bg = 'love', blend = 10 },
          StatusLineNC = { fg = 'subtle', bg = 'surface' },
        }
      })
      vim.cmd [[colorscheme rose-pine]]
    end,
  }
}
