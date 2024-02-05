return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		local events = require("neo-tree.events")
		local popups = require("neo-tree.ui.popups")

		vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
		vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
		vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
		vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

		require("neo-tree").setup({
			-- close_if_last_window = true,
			window = {
				mappings = {
					["<space>"] = {
						"toggle_node",
						nowait = true,
					},
					["P"] = {
						"toggle_preview",
						config = {
							use_float = false,
							use_image_nvim = false,
						},
					},
					["pp"] = function(state)
						local node = state.tree:get_node()
						require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
					end,
				},
			},
			source_selector = {
				winbar = true,
				statusline = false,
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
			git_status = {
				window = {
					mappings = {
						["gpp"] = "git_push",
						["gp"] = function()
							local result = vim.fn.systemlist({ "git", "pull" })
							events.fire_event(events.GIT_EVENT)
							popups.alert("git pull", result)
						end,
						["gf"] = function()
							local result = vim.fn.systemlist({ "git", "fetch" })
							events.fire_event(events.GIT_EVENT)
							popups.alert("git fetch", result)
						end,
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
				use_libuv_file_watcher = true,
			},
		})

		vim.keymap.set("n", "\\", "<Cmd>Neotree reveal<CR>")
	end,
}
