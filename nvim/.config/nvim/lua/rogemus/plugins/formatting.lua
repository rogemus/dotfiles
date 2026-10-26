-- ─── Format on save ───────────────────────────────────────────────
vim.g.auto_formatter_enabled = false

-- ─── Formatters ───────────────────────────────────────────────────
local function is_prettier_config(name)
  return name:match("^%.prettierrc") ~= nil or name:match("^prettier%.config%.") ~= nil
end

-- Returns a conform condition that is true when a matching config exists upward from the file
local function has_config(matcher)
  return function(_, ctx)
    return vim.fs.find(matcher, { path = ctx.filename, upward = true })[1] ~= nil
  end
end

local has_prettier = has_config(is_prettier_config)
local has_biome = has_config({ "biome.json", "biome.jsonc" })

local format_opts = {
  lsp_format = "fallback",
  async = false,
  timeout_ms = 3000,
}

-- prettier first (condition-gated), then biome, then oxfmt as unconditional fallback
local web_formatters = { "prettierd", "prettier", "biome", "oxfmt", stop_after_first = true }

local opts = {
  formatters_by_ft = {
    html = web_formatters,
    javascript = web_formatters,
    typescript = web_formatters,
    javascriptreact = web_formatters,
    typescriptreact = web_formatters,
    vue = web_formatters,
    css = web_formatters,
    json = web_formatters,
    jsonc = web_formatters,
    markdown = web_formatters,
    yaml = { "yamlfmt" },
    lua = { "stylua" },
    bash = { "shfmt" },
    sh = { "shfmt" },
    go = { "gofmt", "goimports" },
    sql = { "pg_format" },
  },
  format_on_save = function()
    if not vim.g.auto_formatter_enabled then
      return
    end
    return format_opts
  end,
}

-- Add conform to 'runtimepath' and configure it on first use, returns the module
local function load_conform()
  require("rogemus.lazy").once("conform", { "conform.nvim" }, function()
    local conform = require("conform")
    -- conditions gate each formatter to its own project type
    conform.formatters.prettierd = { condition = has_prettier }
    conform.formatters.prettier = { condition = has_prettier }
    conform.formatters.biome = { condition = has_biome }
    conform.setup(opts)
  end)
  return require("conform")
end

-- ─── Format on save toggle ────────────────────────────────────────
-- Loading conform here registers its format_on_save autocmd
vim.api.nvim_create_user_command("FormatToggle", function()
  load_conform()
  vim.g.auto_formatter_enabled = not vim.g.auto_formatter_enabled
  local msg = vim.g.auto_formatter_enabled and "Format on Save enabled!" or "Format on Save disabled!"
  print(msg)
end, { desc = "Toggle AutoFormatter" })

-- ─── Format keymap ────────────────────────────────────────────────
local format_buffer = function()
  load_conform().format(format_opts)
  print("File formatted!")
end

vim.keymap.set("n", "<leader>F", format_buffer, { desc = "[F]ormat file or range (in visual mode)" })
