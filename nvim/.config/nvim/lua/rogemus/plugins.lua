return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
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
      require("neo-tree").setup({
        window = {
          mappings = {
           ["P"] = function(state)
              local node = state.tree:get_node()
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end
          }
        },
        source_selector = {
            winbar = false,
            statusline = false
        },
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
      { "<leader>fs", "<cmd>Telescope live_grep<cr>",  desc = "Grep in files (Find in Files)" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",   desc = "Recent Files" },
    },
    config = function()
      require("telescope").setup({
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
      require("nvim-treesitter.configs").setup({
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
    "airblade/vim-gitgutter",
    config = function()
      vim.cmd("GitGutterLineNrHighlightsEnable")
      -- vim.cmd("GitGutterLineHighlightsEnable")
    end
  },
  {
    "terrortylor/nvim-comment",
    config = function()
      require('nvim_comment').setup({
        create_mappings = false
      })
    end
  },
  { "neovim/nvim-lspconfig" },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'L3MON4D3/LuaSnip' },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require('lualine').setup({
        options = {
          theme = 'auto',
          section_separators = '',
          component_separators = '',
          disabled_filetypes = { 'neo-tree' }
        }
      })
    end
  }
}
