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
			commands = {
				close_all_hidden_buffers = function()
					vim.cmd("WipeWindowlessBufs")
				end,
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
				github_file_link = function(state)
					local node = state.tree:get_node()
					if node.type == "message" then
						return
					end
					local url = get_gh_link(node)
					local msg = "GitHub Link: " .. url

					events.fire_event(events.GIT_EVENT)
					popups.alert("github remote url", msg)
				end,
				github_open_file = function(state)
					local node = state.tree:get_node()
					if node.type == "message" then
						return
					end
					local url = get_gh_link(node)
					vim.fn.jobstart({ "open", url }, { detach = true })
				end,
				filetree_toggle = function()
					vim.cmd("Neotree reveal")
					vim.cmd("wincmd l")
					vim.cmd("Neotree toggle")
				end,
				git_pull = function()
					local result = vim.fn.systemlist({ "git", "pull" })
					events.fire_event(events.GIT_EVENT)
					popups.alert("git pull", result)
				end,
				git_fetch = function()
					local result = vim.fn.systemlist({ "git", "fetch" })
					events.fire_event(events.GIT_EVENT)
					popups.alert("git fetch", result)
				end,
				git_branch = function()
					local result = vim.fn.systemlist({ "git", "branch" })
					events.fire_event(events.GIT_EVENT)
					popups.alert("git branch", result)
				end,
				git_checkout = function()
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

							if vim.v.shell_error ~= 0 or (#result > 0 and vim.startswith(result[1], "fatal:")) then
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
					["gh"] = "github_file_link",
					["gH"] = "github_open_file",
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
					-- {
					-- 	source = "git_status",
					-- 	display_name = " 󰊢 Git ",
					-- },
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
			buffers = {
				window = {
					mappings = {
						["\\"] = "filetree_toggle",
						["D"] = "close_all_hidden_buffers",
					},
				},
			},
			git_status = {
				window = {
					mappings = {
						["\\"] = "filetree_toggle",
						["gP"] = "git_push",
						["gp"] = "git_pull",
						["gf"] = "git_fetch",
						["gb"] = "git_branch",
						["gC"] = "git_checkout",
					},
				},
			},
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_hidden = false,
					hide_gitignored = true,
				},
				find_args = {
					fd = {
						"--exclude",
						".git",
						"--exclude",
						"node_modules",
					},
				},
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
				hijack_netrw_behavior = "disabled",
				use_libuv_file_watcher = true,
			},
		})

		-- vim.keymap.set("n", "\\", "<Cmd>Neotree reveal<CR>")
		vim.keymap.set("n", "\\", "<Cmd>Neotree float reveal<CR>")
	end,
}
