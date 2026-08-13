function _G.native_find(text, _)
  local files = vim.fn.globpath(vim.o.path, "*", false, true)
  local seen, result = {}, {}
  for _, f in ipairs(files) do
    if vim.fn.isdirectory(f) == 0 then
      local norm = vim.fs.normalize(f)
      if not seen[norm] then
        seen[norm] = true
        result[#result + 1] = norm
      end
    end
  end
  return vim.fn.matchfuzzy(result, text)
end

vim.opt.findfunc = "v:lua.native_find"

vim.keymap.set("n", "<leader>fn", ":find ", { silent = false })
