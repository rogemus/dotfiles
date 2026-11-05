-- ─── neo-tree ─────────────────────────────────────────────────────
local opts = {
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
    toggle_quickfix = function(state)
      local node = state.tree:get_node()
      if node.type ~= "file" then
        return
      end
      local path = node:get_id()
      local rel = vim.fn.fnamemodify(path, ":.")
      local current = vim.fn.getqflist()
      local items = vim.tbl_filter(function(item)
        return vim.api.nvim_buf_get_name(item.bufnr) ~= path
      end, current)
      if #items == #current then
        table.insert(items, { filename = path, lnum = 1, text = vim.fn.fnamemodify(path, ":t") })
        vim.notify("Quickfix added (" .. #items .. "): " .. rel, vim.log.levels.INFO)
      else
        vim.notify("Quickfix removed (" .. #items .. "): " .. rel, vim.log.levels.WARN)
      end
      vim.fn.setqflist({}, "r", { items = items })
      require("neo-tree.sources.manager").refresh("filesystem")
    end,
    filetree_toggle = function()
      vim.cmd("Neotree reveal")
      vim.cmd("wincmd l")
      vim.cmd("Neotree toggle")
    end,
  },
  window = {
    mappings = {
      ["\\"] = { "filetree_toggle", desc = "Hide file tree" },
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
      ["Q"] = { "toggle_quickfix", desc = "Toggle file in quickfix" },
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
        staged = "",
        conflict = "",
      },
    },
  },
  filesystem = {
    components = {
      -- Marks files that are in the quickfix list
      quickfix = function(_, node)
        local paths = {}
        for _, item in ipairs(vim.fn.getqflist()) do
          paths[vim.api.nvim_buf_get_name(item.bufnr)] = true
        end
        if node.type == "file" and paths[node:get_id()] then
          return { text = " ●", highlight = "DiagnosticWarn" }
        end
        return {}
      end,
    },
    check_gitignore_in_search = true,
    hijack_netrw_behavior = "disabled",
    use_libuv_file_watcher = true,
    find_command = "fd",
    find_args = {
      fd = vim
        .iter({ ".git", "dist", "node_modules", ".idea", "storybook-static", "coverage" })
        :map(function(dir)
          return { "--exclude", dir }
        end)
        :flatten()
        :totable(),
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
}

-- Add neo-tree and its dependencies to 'runtimepath' and configure it on first use
local function load_neotree()
  require("rogemus.lazy").once("neo-tree", { "plenary.nvim", "nui.nvim", "neo-tree.nvim" }, function()
    -- Show the quickfix marker right after the file name
    opts.renderers = { file = vim.deepcopy(require("neo-tree.defaults").renderers.file) }
    for _, item in ipairs(opts.renderers.file) do
      if item[1] == "container" then
        for i, comp in ipairs(item.content) do
          if comp[1] == "clipboard" then
            table.insert(item.content, i + 1, { "quickfix", zindex = 10 })
            break
          end
        end
      end
    end
    require("neo-tree").setup(opts)
  end)
end

require("rogemus.lazy").command("Neotree", load_neotree)

-- ─── Keymaps ──────────────────────────────────────────────────────
vim.keymap.set("n", "\\", function()
  load_neotree()
  vim.cmd("Neotree float reveal")
end, { desc = "Open file tree" })
