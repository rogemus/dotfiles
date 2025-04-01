local function live_grep_from_project_git_root()
	local function is_git_repo()
		vim.fn.system("git rev-parse --is-inside-work-tree")

		return vim.v.shell_error == 0
	end

	local function get_git_root()
		local dot_git_path = vim.fn.finddir(".git", ".;")
		return vim.fn.fnamemodify(dot_git_path, ":h")
	end

	local opts = {}

	if is_git_repo() then
		opts = {
			cwd = get_git_root(),
		}
	end

	require("telescope.builtin").live_grep(opts)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "TelescopeResults",
	callback = function(ctx)
		vim.api.nvim_buf_call(ctx.buf, function()
			vim.fn.matchadd("TelescopeParent", "\t\t.*$")
			vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
		end)
	end,
})

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-ui-select.nvim",
	},
	keys = {
		{ "=", "<cmd>Telescope buffers<cr>", desc = "Open files" },
		{ "<leader>o", "<cmd>Telescope buffers<cr>", desc = "Open files" },
		{ "<leader>fo", "<cmd>Telescope buffers<cr>", desc = "Open files" },
		{ "<leader>fs", live_grep_from_project_git_root, desc = "Grep in files (Find in Files)" },
		{ "-", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find File" },
		{ "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files" },
		-- { "<leader>ff", find_files_from_project_git_root, desc = "Find File" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
		{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
		{ "<leader>s/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in current file" },
		{ "<leader>ds", "<cmd>Telescope diagnostics<cr>", desc = "LSP diagnostics" },
		{
			"<leader>D",
			function()
				require("telescope.builtin").diagnostics({
					layout_strategy = "vertical",
					wrap_results = true,
				})
			end,
			desc = "LSP diagnostics",
		},
	},
	config = function()
		local actions = require("telescope.actions")
		local telescope = require("telescope")

		telescope.setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({
						-- even more opts
					}),
				},
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = false, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				},
			},
			defaults = {
				file_ignore_patterns = { "^.git/", "^node_modules/", "yarn.lock" },
				mappings = {
					i = {
						["<C-b>"] = actions.delete_buffer,
					},
				},
			},
			pickers = {
				find_files = {
					find_command = { "fd", "--type", "f", "--color", "never" },
				},
			},
		})

		telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
	end,
}
