-- Install all plugins
vim.pack.add({
  -- Icons (dependency for many plugins)
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },

  -- Colorscheme
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

  -- LSP ecosystem
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/williamboman/mason.nvim" },
  { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },

  -- Completion
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1.0"),
  },

  -- Fuzzy finder
  { src = "https://github.com/ibhagwan/fzf-lua" },

  -- Statusline
  { src = "https://github.com/nvim-lualine/lualine.nvim" },

  -- Git integration
  { src = "https://github.com/lewis6991/gitsigns.nvim" },

  -- File explorer
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },

  -- Navigation
  { src = "https://github.com/folke/flash.nvim" },

  -- Formatting
  { src = "https://github.com/stevearc/conform.nvim" },
}, {
  load = true,
})

-- Load plugin configurations (after vim.pack.add so plugins are available)
require("rogemus.plugins.icons")
require("rogemus.plugins.colorscheme")
require("rogemus.plugins.treesitter") -- Native 0.12 treesitter config (no plugin)
require("rogemus.plugins.lsp")
require("rogemus.plugins.blink_cmp")
require("rogemus.plugins.fzf")
require("rogemus.plugins.lualine")
require("rogemus.plugins.gitsigns")
require("rogemus.plugins.file-explorer")
require("rogemus.plugins.flash")
require("rogemus.plugins.formatting")
