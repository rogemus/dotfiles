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

		local get_gh_link = function(node)
			local path = node:get_id()
			local rel_path = vim.fn.fnamemodify(path, ":~:.")
			local origin = vim.fn.systemlist({ "git", "config", "--get", "remote.origin.url" })
			local repo = origin[1]:gsub("^[%a_@]+:", ""):gsub("%.git", "")
			local branch = vim.fn.systemlist({ "git", "branch", "--show-current" })
			local gh_domain = "https://github.com/"
			return string.format("%s/%s/blob/%s/%s", gh_domain, repo, branch[1], rel_path)
		end

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
					["O"] = function(state)
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
					["pp"] = function(state)
						local node = state.tree:get_node()
						require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
					end,
					["gh"] = function(state)
						local node = state.tree:get_node()
						if node.type == "message" then
							return
						end
						local url = get_gh_link(node)
						local msg = "GitHub Link: " .. url

						events.fire_event(events.GIT_EVENT)
						popups.alert("github remote url", msg)
					end,
					["gH"] = function(state)
						local node = state.tree:get_node()
						if node.type == "message" then
							return
						end
						local url = get_gh_link(node)
						vim.fn.jobstart({ "open", url }, { detach = true })
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
						["gC"] = function()
							local popup_options = {
								relative = "win",
								position = {
									row = vim.api.nvim_win_get_height(0) - 3,
									col = 0,
								},
								size = vim.fn.winwidth(0) - 2,
							}
							inputs.input("Branch Name: ", "", function(msg)
								local result = vim.fn.systemlist({ "git", "checkout", msg })

								if vim.v.shell_error ~= 0 or (#result > 0 and vim.startswith(result[1], "error:")) then
									result = vim.fn.systemlist({ "git", "checkout", "-b", msg })

									if
										vim.v.shell_error ~= 0 or (#result > 0 and vim.startswith(result[1], "fatal:"))
									then
										popups.alert("ERROR: git checkout -b", result)
										return
									end

									events.fire_event(events.GIT_EVENT)
									popups.alert("git checkout -b", result)
								end

								if vim.v.shell_error ~= 0 or (#result > 0 and vim.startswith(result[1], "fatal:")) then
									popups.alert("git checkout -b", result)
									return
								end

								events.fire_event(events.GIT_EVENT)
								popups.alert("git checkout", result)
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
