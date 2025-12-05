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

    local function url_encode(str)
      str = str:gsub("\n", "\r\n")
      str = str:gsub("([^%w%-_%.~])", function(c)
        return string.format("%%%02X", string.byte(c))
      end)
      return str
    end

    local function extract_git_domain(remote_url)
      -- Try HTTPS pattern first
      local domain = remote_url:match("^https?://([^/]+)/")
      if not domain then
        -- Try SSH pattern
        domain = remote_url:match("@([^:]+):")
      end
      return domain
    end

    local function run_cmd(cmd)
      local handle = io.popen(cmd)
      local result = handle:read("*a")
      handle:close()
      return result:gsub("%s+", "")
    end

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
        open_file_in_web_git = function(state)
          local node = state.tree:get_node()
          local file_path = node.id

          -- Get remote URL and branch
          local remote_url = run_cmd("git remote get-url origin")
          local branch = run_cmd("git rev-parse --abbrev-ref HEAD")

          -- Get repo root and current file path relative to it
          local repo_root = run_cmd("git rev-parse --show-toplevel")

          -- Detect platform and extract components
          local url
          if remote_url:match("github") then
            -- GitHub
            local owner, repo = remote_url:match("github.com.-/(.-)%.git")
            url = string.format("https://github.com/%s/%s/blob/%s/%s", owner, repo, branch, file_path)
          elseif remote_url:match("bitbucket") then
            if remote_url:match("/scm/") or remote_url:match("/projects/") then
              -- Bitbucket Server (self-hosted)
              local domain = remote_url:match("@(.-):") or remote_url:match("https?://(.-)/")
              local project, repo = remote_url:match("/scm/(.-)/(.-)%.git")
                or remote_url:match("/projects/(.-)/repos/(.-)%.git")
              url = string.format(
                "https://%s/projects/%s/repos/%s/browse/%s?at=refs/heads/%s",
                domain,
                project,
                repo,
                file_path,
                branch
              )
            else
              -- Bitbucket Cloud
              local owner, repo = remote_url:match("bitbucket.org.-/(.-)%.git")
              url = string.format("https://bitbucket.org/%s/%s/src/%s/%s", owner, repo, branch, file_path)
            end
          else
            print("Unsupported platform or unknown remote URL")
            return
          end

          vim.fn.systemlist({ "open", url })
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
          ["oo"] = "open_file_in_web_git",
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
