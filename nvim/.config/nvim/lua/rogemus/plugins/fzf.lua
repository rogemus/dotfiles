return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "=", "<cmd>FzfLua buffers<cr>", desc = "Open files" },
    { "<leader>fs", "<cmd>FzfLua live_grep<cr>", desc = "Grep in files (Find in Files)" },
    { "-", "<cmd>FzfLua files<cr>", desc = "Find File" },
    { "0", "<cmd>FzfLua oldfiles<cr>", desc = "Recent Files" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent Files" },
    { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git Status" },
    { "<leader>/", "<cmd>FzfLua grep_curbuf<cr>", desc = "Find in current file" },
  },
  config = function()
    require("fzf-lua").setup({
      files = {
        path_shorten = 3,
        formatter = "path.filename_first",
        fd_opts = "--type f --color never --hidden --exclude .git",
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096",
      },
      buffers = {
        path_shorten = 3,
        formatter = "path.filename_first",
        sort_lastused = true,
        show_unlisted = true,
      },
      oldfiles = {
        path_shorten = 3,
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
  end,
}
