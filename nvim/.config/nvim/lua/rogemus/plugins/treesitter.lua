return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			autotag = {
				enable = true,
			},
			ensure_installed = {
				"bash",
				"comment",
				"css",
				"dot",
				"git_config",
				"gitignore",
				"go",
				"gosum",
				"gowork",
				"html",
				"htmldjango",
				"javascript",
				"jsdoc",
				"json",
				"lua",
				"python",
				"query",
				"scss",
				"svelte",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
				"gotmpl",
			},
			auto_install = true,
			sync_install = false,
			highlight = {
				enable = true,
				is_supported = function(lang)
					if lang == "csv" then
						return false
					end
					return true
				end,
			},
			indent = {
				enable = true,
			},
		})

		vim.filetype.add({
			extension = {
				templ = "templ",
			},
		})
		vim.filetype.add({
			extension = {
				tmpl = "gotmpl",
			},
		})

		vim.treesitter.language.register("gotmpl", "gotmpl")
	end,
}
