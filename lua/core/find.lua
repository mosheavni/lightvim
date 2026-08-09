function _G.native_find(text, _)
  local files = vim.fn.glob("**/*", false, true)
  local result = {}
  for _, f in ipairs(files) do
    if vim.fn.isdirectory(f) == 0 then
      result[#result + 1] = f
    end
  end
  return vim.fn.matchfuzzy(result, text)
end

vim.opt.findfunc = "v:lua.native_find"

vim.keymap.set("n", "<leader>fn", ":find ", { silent = false })
