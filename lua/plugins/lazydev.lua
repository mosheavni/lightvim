---@type PluginSpec
return {
  src = 'https://github.com/folke/lazydev.nvim',
  data = {
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('lazydev').setup { path = '${3rd}/luv/library', words = { 'vim%.uv' } }
    end,
  },
}
