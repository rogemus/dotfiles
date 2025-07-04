return {
  "saghen/blink.cmp",
  dependencies = {},

  version = "1.*",
  opts = {
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    },

    completion = {
      list = {
        selection = {
          auto_insert = false,
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
  },
  opts_extend = { "sources.default" },
}
