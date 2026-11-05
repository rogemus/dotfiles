-- ─── Remove entries ───────────────────────────────────────────────
vim.keymap.set("n", "dd", function()
  local list = vim.fn.getqflist()
  local line = vim.fn.line(".")
  table.remove(list, line)
  vim.fn.setqflist(list, "r")
  vim.fn.cursor(line, 1)
end, { buffer = true, silent = true, desc = "Remove quickfix entry under cursor" })

vim.keymap.set("n", "D", function()
  vim.fn.setqflist({}, "r")
end, { buffer = true, silent = true, desc = "Remove all quickfix entries" })

vim.keymap.set("v", "d", function()
  local list = vim.fn.getqflist()
  local first, last = vim.fn.line("v"), vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  -- Remove from the bottom so the indices don't shift
  for i = last, first, -1 do
    table.remove(list, i)
  end
  vim.fn.setqflist(list, "r")
  vim.api.nvim_input("<Esc>")
  vim.fn.cursor(first, 1)
end, { buffer = true, silent = true, desc = "Remove selected quickfix entries" })
