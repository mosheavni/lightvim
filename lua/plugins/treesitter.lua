vim.pack.add { { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' } }

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('myconfig.treesitter', { clear = true }),
  pattern = '*',
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang then return end

    local function attach()
      if not vim.treesitter.query.get(lang, 'highlights') then return end
      if not pcall(vim.treesitter.start, ev.buf) then return end
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      local win = vim.api.nvim_get_current_win()
      if not vim.wo[win].diff then
        vim.wo[win][0].foldmethod = 'expr'
        vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      end
    end

    if vim.treesitter.language.add(lang) then
      attach()
    elseif vim.tbl_contains(require('nvim-treesitter').get_available(), lang) then
      require('nvim-treesitter').install(lang):await(function()
        vim.treesitter.language.add(lang)
        attach()
      end)
    end
  end,
})

require('nvim-treesitter').install {
  'awk', 'bash', 'comment', 'css', 'csv', 'diff', 'dockerfile', 'editorconfig', 'embedded_template',
  'git_config', 'git_rebase', 'gitcommit', 'gitignore', 'go', 'gomod', 'gosum', 'gotmpl', 'gowork',
  'graphql', 'groovy', 'hcl', 'helm', 'hjson', 'html', 'http', 'ini', 'java',
  'javascript', 'jinja', 'jinja_inline', 'jq', 'json', 'json5', 'latex', 'lua', 'luadoc',
  'luap', 'make', 'markdown', 'markdown_inline', 'passwd', 'pem', 'printf', 'python', 'query',
  'regex', 'requirements', 'rust', 'scss', 'sql', 'ssh_config', 'terraform', 'toml', 'tsx',
  'typescript', 'vim', 'vimdoc', 'xml', 'yaml', 'zsh'
}
