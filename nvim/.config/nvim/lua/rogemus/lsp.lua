local keymap = vim.keymap
local lsp = vim.lsp
local bo = vim.bo
local api = vim.api


local cmp = require('cmp')
local luasnip = require('luasnip')
local capabilities = lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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

require("mason").setup()
require("mason-lspconfig").setup()

local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true
})

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end


  nmap('<leader>rn', lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', lsp.buf.signature_help, 'Signature Documentation')

  -- keymap.set('n', 'gD', lsp.buf.declaration, opts)
  -- keymap.set('n', 'gd', lsp.buf.definition, opts)
  -- keymap.set('n', 'K', lsp.buf.hover, opts)
  -- keymap.set('n', 'gi', lsp.buf.implementation, opts)
  -- keymap.set('n', '<C-k>', lsp.buf.signature_help, opts)
  -- keymap.set('n', '<leader>D', lsp.buf.type_definition, opts)
  -- keymap.set('n', '<leader>rn', lsp.buf.rename, opts)
  -- keymap.set({ 'n', 'v' }, '<leader>ca', lsp.buf.code_action, opts)
  -- keymap.set('n', 'gr', lsp.buf.references, opts)

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = "buffer" },
  },
}
