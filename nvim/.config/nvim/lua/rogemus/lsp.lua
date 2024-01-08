local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local bo = vim.bo

local lspconfig = require('lspconfig')
local cmp = require('cmp')

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local luasnip = require('luasnip')

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = "buffer" },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),     -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4),      -- Down
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  }),
}

local servers = {
  "bashls",
  "dotls",
  "eslint",
  "jsonls",
  "lua_ls",
  "pyright",
  "tsserver",
  "svelte",
}

lspconfig.html.setup{
  filetypes = { 'html', 'htmldjango' },
  capabilities = capabilities,
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

api.nvim_create_autocmd('LspAttach', {
  group = api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    bo[ev.buf].omnifunc = 'v:lua.lsp.omnifunc'
    -- Buffer local mappings.
    -- See `:help lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    keymap.set('n', 'gD', lsp.buf.declaration, opts)
    keymap.set('n', 'gd', lsp.buf.definition, opts)
    keymap.set('n', 'K', lsp.buf.hover, opts)
    keymap.set('n', 'gi', lsp.buf.implementation, opts)
    keymap.set('n', '<C-k>', lsp.buf.signature_help, opts)
    keymap.set('n', '<leader>D', lsp.buf.type_definition, opts)
    keymap.set('n', '<leader>rn', lsp.buf.rename, opts)
    keymap.set({ 'n', 'v' }, '<leader>ca', lsp.buf.code_action, opts)
    keymap.set('n', 'gr', lsp.buf.references, opts)
    keymap.set('n', '<C-f>', function()
      lsp.buf.format { async = true }
    end, opts)
  end,
})
