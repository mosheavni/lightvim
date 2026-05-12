vim.pack.add { { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' } }

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('myconfig.treesitter', { clear = true }),
  pattern = '*',
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang then return end

    local ok = vim.treesitter.language.add(lang)
    if not ok then
      local avail = require('nvim-treesitter').get_available()
      if vim.tbl_contains(avail, lang) then
        vim.notify('Parser available for ' .. lang .. '. Please add to install func', vim.log.levels.INFO)
      end
      return
    end

    if not pcall(vim.treesitter.start, ev.buf) then return end

    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
})

require('nvim-treesitter').install {
  'awk', 'bash', 'comment', 'css', 'csv', 'diff', 'dockerfile', 'editorconfig',
  'embedded_template', 'git_config', 'git_rebase', 'gitcommit', 'gitignore',
  'go', 'gomod', 'gosum', 'gotmpl', 'gowork', 'html', 'java', 'javascript',
  'json', 'json5', 'lua', 'make', 'markdown', 'markdown_inline', 'python',
  'regex', 'rust', 'sql', 'toml', 'tsx', 'typescript', 'vim', 'yaml',
}
