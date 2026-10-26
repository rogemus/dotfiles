require("blink.cmp").setup({
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
})
