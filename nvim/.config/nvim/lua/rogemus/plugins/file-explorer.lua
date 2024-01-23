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
		vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
	end,
}
