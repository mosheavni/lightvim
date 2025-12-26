---@type PluginSpec
return {
  src = 'https://github.com/nvim-treesitter/nvim-treesitter',
  version = 'main',
  data = {
    build = ':TSUpdate',
    config = function()
      local augroup = vim.api.nvim_create_augroup('myconfig.treesitter', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        pattern = { '*' },
        callback = function(event)
          local filetype = event.match
          local lang = vim.treesitter.language.get_lang(filetype)
          if not lang then
            return
          end

          local is_installed, _ = vim.treesitter.language.add(lang)

          if not is_installed then
            local available_langs = require('nvim-treesitter').get_available()
            if vim.tbl_contains(available_langs, lang) then
              vim.notify('Parser available for ' .. lang .. '. Please add to install func', vim.log.levels.INFO)
            end
            return
          end

          if not pcall(vim.treesitter.start, event.buf) then
            return
          end

          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          vim.wo[0][0].foldmethod = 'expr'
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
      })

      require('nvim-treesitter').install {
        'awk',
        'bash',
        'comment',
        'css',
        'csv',
        'diff',
        'dockerfile',
        'editorconfig',
        'embedded_template',
        'git_config',
        'git_rebase',
        'gitcommit',
        'gitignore',
        'go',
        'gomod',
        'gosum',
        'gotmpl',
        'gowork',
        'html',
        'java',
        'javascript',
        'json',
        'json5',
        'lua',
        'make',
        'markdown',
        'markdown_inline',
        'python',
        'regex',
        'rust',
        'sql',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'yaml',
      }
    end,
  },
}
