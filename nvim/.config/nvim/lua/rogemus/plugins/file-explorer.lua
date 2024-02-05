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
		local inputs = require("neo-tree.ui.inputs")

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
						["gP"] = "git_push",
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
						["gb"] = function()
							local result = vim.fn.systemlist({ "git", "branch" })
							events.fire_event(events.GIT_EVENT)
							popups.alert("git branch", result)
						end,
						["gch"] = function()
							local width = vim.fn.winwidth(0) - 2
							local row = vim.api.nvim_win_get_height(0) - 3
							local popup_options = {
								relative = "win",
								position = {
									row = row,
									col = 0,
								},
								size = width,
							}

							inputs.input("Branch Name: ", "", function(msg)
								local cmd = { "git", "checkout", msg }
								local title = "git checkout"
								local result = vim.fn.systemlist(cmd)

								if vim.v.shell_error ~= 0 or (#result > 0 and vim.startswith(result[1], "error:")) then
									popups.alert("ERROR: git checkout", result)
									return
								end

								events.fire_event(events.GIT_EVENT)
								popups.alert(title, result)
							end, popup_options)
						end,
						["gcH"] = function()
							local width = vim.fn.winwidth(0) - 2
							local row = vim.api.nvim_win_get_height(0) - 3
							local popup_options = {
								relative = "win",
								position = {
									row = row,
									col = 0,
								},
								size = width,
							}

							inputs.input("New Branch Name: ", "", function(msg)
								local cmd = { "git", "checkout", "-b", msg }
								local title = "git checkout -b"
								local result = vim.fn.systemlist(cmd)

								if vim.v.shell_error ~= 0 or (#result > 0 and vim.startswith(result[1], "error:")) then
									popups.alert("ERROR: git checkout -b", result)
									return
								end

								if vim.v.shell_error ~= 0 or (#result > 0 and vim.startswith(result[1], "fatal:")) then
									popups.alert("ERROR: git checkout -b", result)
									return
								end

								events.fire_event(events.GIT_EVENT)
								popups.alert(title, result)
							end, popup_options)
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
