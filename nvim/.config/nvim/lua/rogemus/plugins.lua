return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      local config = require("catppuccin")

      config.setup({
        integrations = {
          nvimtree = true,
          gitgutter = true,
          treesitter = true,
        },
        color_overrides = {
          mocha = {
            base = "#000000",
            mantle = "#000000",
            crust = "#212136",
          },
        },
        highlight_overrides = {
          mocha = function(mocha)
            return {
              Whitespace = { fg = mocha.crust }
            }
          end,
        }
      })
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim"
    },
    config = function()
      local config = require("neo-tree")
      config.setup({
        default_component_configs = {
          git_status = {
            symbols = {
              added = "+",
              modified = "*"
            },
          },
        },
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_hidden = false,
          },
          follow_current_file = {
            enabled = true,
          },
          use_libuv_file_watcher = true
        }
      })
      vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>fs", "<cmd>Telescope live_grep§<cr>", desc = "Grep in files (Find in Files)" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",   desc = "Recent Files" },
    },
    config = function()
      local configs = require("telescope")
      configs.setup({
        pickers = {
          find_files = {
            hidden = true
          }
        }
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = {
          "lua",
          "vim",
          "javascript",
          "typescript",
          "svelte",
          "python",
          "css",
          "scss",
          "json",
          "html",
          "htmldjango",
          "git_config",
          "bash",
          "dot"
        },
        auto_install = true,
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup {
      }
    end,
  },
  {
    "airblade/vim-gitgutter",
    config = function()
      vim.cmd("GitGutterLineNrHighlightsEnable")
      -- vim.cmd("GitGutterLineHighlightsEnable")
    end
  },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "VonHeikemen/lsp-zero.nvim",        branch = "v3.x" },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/nvim-cmp" },
  { "L3MON4D3/LuaSnip" },
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here
    },
    lazy = false,
  },
}
