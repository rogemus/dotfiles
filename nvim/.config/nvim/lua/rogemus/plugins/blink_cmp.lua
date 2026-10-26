-- ─── Completion (blink.cmp) ───────────────────────────────────────
local opts = {
  keymap = {
    preset = "enter",
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
  },

  completion = {
    accept = {
      auto_brackets = {
        enabled = false,
      },
    },
    list = {
      selection = {
        auto_insert = false,
        preselect = true,
      },
    },
    menu = {
      border = "rounded",
      winhighlight = "Normal:CmpNormal",
    },
    documentation = {
      window = {
        border = "rounded",
        winhighlight = "Normal:CmpNormal",
      },
      auto_show = true,
    },
  },
  signature = {
    enabled = true,
    window = {
      border = "rounded",
      winhighlight = "Normal:CmpNormal",
    },
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    providers = {
      snippets = {
        opts = { extended_filetypes = { typescriptreact = { "typescript" } } },
      },
    },
  },

  cmdline = {
    keymap = { preset = "inherit" },
    completion = {
      menu = {
        auto_show = true,
      },
    },
  },

  fuzzy = { implementation = "prefer_rust_with_warning" },
}

local M = {}

-- Add blink.cmp to 'runtimepath' and configure it on first use, returns the module
function M.get()
  require("rogemus.lazy").once("blink.cmp", { "blink.cmp" }, function()
    require("blink.cmp").setup(opts)
  end)
  return require("blink.cmp")
end

-- lsp.lua loads it right after startup, this covers typing or the command line before that
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  once = true,
  callback = function()
    M.get()
  end,
})

return M
