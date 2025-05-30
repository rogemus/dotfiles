vim.g.auto_formater_enabled = false

vim.api.nvim_create_user_command("FormatToggle", function()
  vim.g.auto_formater_enabled = not vim.g.auto_formater_enabled
  local msg = vim.g.auto_formater_enabled and "Format on Save enabled!" or "Format on Save disabled!"
  print(msg)
end, { desc = "Toggle AutoFormatter" })

return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "biome" },
        typescript = { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        -- css = { "biome" },
        json = { "biome" },
        -- html = { "prettier" },
        -- javascript = { "prettier" },
        -- typescript = { "prettier" },
        -- javascriptreact = { "prettier" },
        -- typescriptreact = { "prettier" },
        -- css = { "prettier" },
        -- markdown = { "prettier" },
        yaml = { "yamlfmt" },
        lua = { "stylua" },
        bash = { "shfmt" },
        sh = { "shfmt" },
        go = { "gofmt", "goimports" },
        sql = { "pgformatter" },
      },
      format_on_save = function()
        if not vim.g.auto_formater_enabled then
          return
        end
        return {
          lsp_fallback = true,
          async = false,
          timeout_ms = 3000,
        }
      end,
    })

    local format_buffer = function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 3000,
      })
      print("File formatted!")
    end

    vim.keymap.set("n", "<leader>F", format_buffer, { desc = "[F]ormat file or range (in visual mode)" })
  end,
}
