local lsp_zero = require("lsp-zero")
local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
local cmp_format = require("lsp-zero").cmp_format()

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

cmp.setup({
  formatting = cmp_format,
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({select = false}),
    ["<C-Space>"] = cmp.mapping.complete(),
  })
})

require("mason").setup({})
require("mason-lspconfig").setup({
  handlers = {
    lsp_zero.default_setup,
  },
  ensure_installed = {
    "tsserver",
    "lua_ls",
    "eslint",
    "svelte"
  }
})
