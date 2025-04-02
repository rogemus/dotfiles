return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

    require("neo-tree").setup({
      commands = {
        open_in_finder = function(state)
          local node = state.tree:get_node()
          if node.type == "message" then
            return
          end
          if node.type == "directory" then
            vim.fn.systemlist({ "open", node.id })
            return
          end
          local dir = node:get_parent_id()
          vim.fn.systemlist({ "open", dir })
        end,
        focus_parent = function(state)
          local node = state.tree:get_node()
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end,
        filetree_toggle = function()
          vim.cmd("Neotree reveal")
          vim.cmd("wincmd l")
          vim.cmd("Neotree toggle")
        end,
      },
      window = {
        mappings = {
          ["\\"] = "filetree_toggle",
          ["<space>"] = {
            "toggle_node",
            nowait = true,
          },
          ["P"] = {
            "toggle_preview",
            config = {
              use_float = true,
              use_image_nvim = false,
            },
          },
          ["O"] = "open_in_finder",
          ["U"] = "focus_parent",
        },
      },
      source_selector = {
        winbar = true,
        statusline = false,
        sources = {
          {
            source = "filesystem",
            display_name = " 󰉓 Files ",
          },
        },
      },
      default_component_configs = {
        git_status = {
          symbols = {
            added = "+",
            modified = "*",
            deleted = "✖",
            renamed = "󰁕",
            untracked = "!!",
            ignored = "",
            unstaged = "",
            staged = "",
            conflict = "",
          },
        },
      },
      filesystem = {
        check_gitignore_in_search = true,
        hijack_netrw_behavior = "disabled",
        use_libuv_file_watcher = true,
        find_command = "fd",
        find_args = {
          fd = {
            "--exclude",
            ".git",
            "--exclude",
            "dist",
            "--exclude",
            "node_modules",
            "--exclude",
            ".idea",
            "--exclude",
            "storybook-static",
            "--exclude",
            "coverage",
          },
        },
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_hidden = false,
          hide_gitignored = true,
          always_show_by_pattern = { ".env*" },
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      },
    })

    vim.keymap.set("n", "\\", "<Cmd>Neotree float reveal<CR>")
  end,
}
