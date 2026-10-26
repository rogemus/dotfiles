-- ─── Gitsigns ─────────────────────────────────────────────────────
-- Loaded when the first buffer is read
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  once = true,
  callback = function()
    require("rogemus.lazy").once("gitsigns", { "gitsigns.nvim" }, function()
      require("gitsigns").setup({
        current_line_blame = true,
      })
    end)
  end,
})
