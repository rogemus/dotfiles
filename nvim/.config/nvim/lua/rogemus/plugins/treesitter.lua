return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = true,
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"lua",
				"vim",
				"javascript",
				"typescript",
				"svelte",
				"python",
				"css",
				"scss",
				"json",
				"html",
				"htmldjango",
				"git_config",
				"bash",
				"dot",
			},
			auto_install = true,
			sync_install = false,
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
		})
	end,
}
