return {
  "hrsh7th/nvim-cmp",
  event = "VeryLazy",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",

    -- "L3MON4D3/LuaSnip",
    -- "saadparwaiz1/cmp_luasnip",

    "dcampos/nvim-snippy",
    "dcampos/cmp-snippy",
  },
  config = function()
    local cmp = require("cmp")
    -- local luasnip = require("luasnip")
    --
    -- luasnip.config.setup({
    --   updateevents = "TextChanged,TextChangedI",
    --   history = false,
    --   -- region_check_events = "InsertEnter",
    --   -- delete_check_events = "TextChanged,InsertLeave",
    --   enable_autosnippets = false,
    -- })

    -- require("luasnip.loaders.from_snipmate").lazy_load()

    cmp.setup({
      window = {
        completion = {
          border = "rounded",
          winhighlight = "Normal:CmpNormal",
        },
        documentation = {
          border = "rounded",
          winhighlight = "Normal:CmpNormal",
        },
      },
      snippet = {
        expand = function(args)
          -- luasnip.lsp_expand(args.body)
          -- require('snippy').expand_snippet(args.body)
          vim.snippet.expand(args.body)
        end,
      },
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      preselect = cmp.PreselectMode.Item,
      mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true }),

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.snippet.jumpable(1) then
            vim.snippet.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.jumpable(-1) then
            vim.snippet.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        --
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   -- elseif luasnip.locally_jumpable(1) then
        --   --   luasnip.jump(1)
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        --
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   elseif luasnip.locally_jumpable(-1) then
        --     luasnip.jump(-1)
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
      }),
      sources = {
        { name = "nvim_lsp" },
        -- { name = "luasnip" },
        { name = "snippy" },
        { name = "path" },
        { name = "buffer", keyword_length = 3 },
      },
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })
  end,
}
