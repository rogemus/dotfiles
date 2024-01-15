return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>fo", "<cmd>Telescope buffers<cr>", desc = "Open files" },
		{ "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Grep in files (Find in Files)" },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
		{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
	},
	config = function()
		require("telescope").setup({
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		})
	end,
}
