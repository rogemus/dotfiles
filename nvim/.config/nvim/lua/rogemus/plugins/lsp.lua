local mason = require("mason")
local mason_tool_installer = require("mason-tool-installer")

-- ─── Language servers ─────────────────────────────────────────────
local servers = {
  html = {
    filetypes = { "html", "htmldjango", "gotmpl" },
  },
  cssls = {},
  bashls = {},
  dotls = {},
  jsonls = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  },
  postgres_lsp = {},
  ts_ls = {
    root_markers = { "package.json", "yarn.lock" },
    workspace_required = true,
  },
  -- denols = {
  --   root_markers = { "deno.json", "deno.jsonc" },
  --   workspace_required = true,
  --   settings = {},
  -- },
  -- svelte = {},
  gopls = {
    settings = {
      gopls = {
        experimentalPostfixCompletions = true,
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        staticcheck = true,
      },
    },
  },
  eslint = {},
  biome = {},
}

-- ─── Tools to install ─────────────────────────────────────────────
-- Mason package names, keep the servers in sync with `servers` above.
-- Not installed on startup, run :MasonToolsInstall after changing this list
local ensure_installed = {
  -- LSP servers
  "html-lsp",
  "css-lsp",
  "bash-language-server",
  "dot-language-server",
  "json-lsp",
  "lua-language-server",
  "postgres-language-server",
  "typescript-language-server",
  "gopls",
  "eslint-lsp",
  -- Formatters
  "prettier",
  "stylua",
  "biome",
  -- LINTERS
  "golangci-lint",
  -- oxc_language_server (oxlint) is not in Mason registry; install manually:
  -- npm i -g oxc-language-server  OR  cargo install oxc_language_server
}

-- ─── LSP keymaps and attach ───────────────────────────────────────
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- fzf-lua is loaded on first use
    local function fzf(name)
      return function()
        require("rogemus.plugins.fzf").get()[name]()
      end
    end
    map("gd", fzf("lsp_definitions"), "[G]oto [D]efinition")
    map("<leader>gr", fzf("lsp_references"), "[G]oto [R]eferences")
    map("gI", fzf("lsp_implementations"), "[G]oto [I]mplementation")
    map("<leader>D", fzf("lsp_typedefs"), "Type [D]efinition")
    map("<leader>ds", fzf("lsp_document_symbols"), "[D]ocument [S]ymbols")
    map("<leader>ws", fzf("lsp_workspace_symbols"), "[W]orkspace [S]ymbols")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("K", function()
      vim.lsp.buf.hover({ border = "rounded" })
    end, "Hover Documentation")

    map("CTRL-S", function()
      vim.lsp.buf.signature_help({ border = "rounded" })
    end, "Show signature help")

    local function client_supports_method(client, method, bufnr)
      if vim.fn.has("nvim-0.11") == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if
      client
      and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
    then
      local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
        end,
      })
    end
  end,
})

-- ─── Mason ────────────────────────────────────────────────────────
mason.setup({
  ui = {
    size = { width = 0.9, height = 0.4 },
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

mason_tool_installer.setup({
  ensure_installed = ensure_installed,
  run_on_start = false,
})

-- ─── Enable servers ───────────────────────────────────────────────
-- Runs right after startup: needs blink.cmp for the capabilities, which is loaded lazily.
-- vim.lsp.enable also starts the servers for buffers that are already open
local function enable_servers()
  local capabilities = require("rogemus.plugins.blink_cmp").get().get_lsp_capabilities()
  for name, cfg in pairs(servers) do
    -- Only values explicitly set above override the defaults. Useful when disabling
    -- certain features of an LSP (for example, turning off formatting for ts_ls)
    cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
    vim.lsp.config(name, cfg)
  end
  vim.lsp.enable(vim.tbl_keys(servers))

  -- oxc formatter/linter LSP, install via: npm i -g oxfmt
  vim.lsp.enable("oxfmt")
end

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.schedule(enable_servers)
  end,
})

-- ─── Diagnostics ──────────────────────────────────────────────────
vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  -- underline = { severity = vim.diagnostic.severity.HINT }
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  } or {},
  virtual_text = {
    source = "if_many",
    spacing = 2,
  },
})
