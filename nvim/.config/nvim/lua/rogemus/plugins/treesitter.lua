return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"vim",
				"javascript",
				"typescript",
				"svelte",
				"python",
				"css",
				"lua",
				"scss",
				"json",
				"html",
				"htmldjango",
				"git_config",
				"bash",
				"dot",
				"query",
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
