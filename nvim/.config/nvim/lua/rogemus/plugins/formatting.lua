vim.g.auto_formater_enabled = false

vim.api.nvim_create_user_command("FormatToggle", function()
  vim.g.auto_formater_enabled = not vim.g.auto_formater_enabled
  local msg = vim.g.auto_formater_enabled and "Format on Save enabled!" or "Format on Save disabled!"
  print(msg)
end, { desc = "Toggle AutoFormatter" })

local conform = require("conform")

local prettier_configs = {
  ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.cjs",
  ".prettierrc.yaml", ".prettierrc.yml", ".prettierrc.mjs",
  "prettier.config.js", "prettier.config.cjs", "prettier.config.ts", "prettier.config.mjs",
}

local function has_prettier(_, ctx)
  return vim.fs.find(prettier_configs, { path = ctx.filename, upward = true })[1] ~= nil
end

local function has_biome(_, ctx)
  return vim.fs.find({ "biome.json", "biome.jsonc" }, { path = ctx.filename, upward = true })[1] ~= nil
end

-- conditions gate each formatter to its own project type
conform.formatters.prettierd = { condition = has_prettier }
conform.formatters.prettier = { condition = has_prettier }
conform.formatters.biome = { condition = has_biome }

conform.setup({
  formatters_by_ft = {
    -- prettier first (condition-gated), then biome, then oxfmt as unconditional fallback
    html = { "prettierd", "prettier", stop_after_first = true },
    javascript = { "prettierd", "prettier", "biome", "oxfmt", stop_after_first = true },
    typescript = { "prettierd", "prettier", "biome", "oxfmt", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", "biome", "oxfmt", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", "biome", "oxfmt", stop_after_first = true },
    vue = { "prettierd", "prettier", "biome", "oxfmt", stop_after_first = true },
    css = { "prettierd", "prettier", "biome", stop_after_first = true },
    json = { "prettierd", "prettier", "biome", "oxfmt", stop_after_first = true },
    jsonc = { "prettierd", "prettier", "biome", "oxfmt", stop_after_first = true },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    yaml = { "yamlfmt" },
    lua = { "stylua" },
    bash = { "shfmt" },
    sh = { "shfmt" },
    go = { "gofmt", "goimports" },
    sql = { "pg_format" },
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
