local base_fd = {
  "--type f",
  "--color never",
  "--hidden",
  "--exclude .git",
}
local base_rg = {
  "--column",
  "--line-number",
  "--no-heading",
  "--color=always",
  "--smart-case",
  "--max-columns=4096",
  "--glob !yarn.lock",
  "--glob !.yarn/*",
  "--glob !common/.yarn/*",
  "--glob !.git/*",
}

local ignore_tests = true
local test_globs = {
  "*.spec.ts",
  "*.spec.tsx",
  "*.spec.js",
  "*.test.ts",
  "*.test.tsx",
  "*.po.ts",
  "*.po.ts",
  "*.assertion.ts",
}

local function search_opts()
  local fd, rg = vim.deepcopy(base_fd), vim.deepcopy(base_rg)
  if ignore_tests then
    for _, glob in ipairs(test_globs) do
      table.insert(fd, "--exclude '" .. glob .. "'")
      table.insert(rg, "--glob '!" .. glob .. "'")
    end
  end
  return { fd_opts = table.concat(fd, " "), rg_opts = table.concat(rg, " ") }
end

local function toggle_tests()
  ignore_tests = not ignore_tests
  vim.notify("FZF test files: " .. (ignore_tests and "ignored" or "shown"), vim.log.levels.INFO)
end

require("fzf-lua").setup({
  files = {
    path_shorten = 6,
    formatter = "path.filename_first",
    fd_opts = table.concat(base_fd, " "),
  },
  grep = {
    rg_opts = table.concat(base_rg, " "),
    git_icons = true,
    no_ignore = false,
    hidden = true,
  },
  buffers = {
    formatter = "path.filename_first",
    sort_lastused = true,
    show_unlisted = false,
    cwd_only = true,
  },
  oldfiles = {
    formatter = "path.filename_first",
  },
  fzf_opts = {
    ["--ansi"] = "",
    ["--prompt"] = "❯ ",
    ["--pointer"] = "▶",
    ["--marker"] = "✓",
    ["--info"] = "inline",
  },
})

-- Keymaps
vim.keymap.set("n", "=", "<cmd>FzfLua buffers<cr>", { desc = "Open files" })
vim.keymap.set("n", "<leader>fs", function()
  require("fzf-lua").live_grep({ rg_opts = search_opts().rg_opts })
end, { desc = "Grep in files (Find in Files)" })
vim.keymap.set("n", "-", function()
  require("fzf-lua").files({ fd_opts = search_opts().fd_opts })
end, { desc = "Find File" })
vim.keymap.set("n", "<leader>ft", toggle_tests, { desc = "Toggle ignoring test files in fzf" })
vim.api.nvim_create_user_command("FzfToggleTests", toggle_tests, { desc = "Toggle ignoring test files in fzf" })
vim.keymap.set("n", "0", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent Files" })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent Files" })
vim.keymap.set("n", "<leader>gs", "<cmd>FzfLua git_status<cr>", { desc = "Git Status" })
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua grep_curbuf<cr>", { desc = "Find in current file" })
vim.keymap.set("n", "<leader>m", "<cmd>FzfLua marks<cr>", { desc = "Marks" })
vim.keymap.set("n", "<leader>td", function()
  require("fzf-lua").grep({ search = "TODO|HACK|PERF|NOTE|FIX|FIXMEs", no_esc = true, rg_opts = search_opts().rg_opts })
end, { desc = "List todos" })
