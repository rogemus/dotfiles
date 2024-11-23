return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			integrations = {
				neotree = true,
				gitgutter = true,
				treesitter = true,
				cmp = true,
				native_lsp = {
					enabled = true,
					inlay_hints = { background = true },
				},
			},
			color_overrides = {
				mocha = {
					base = "#000000",
					mantle = "#000000",
					crust = "#1d1d30",
					-- crust = "#212136",
				},
			},
			highlight_overrides = {
				mocha = function(mocha)
					return {
						Whitespace = { fg = mocha.crust },
						Pmenu = { bg = mocha.crust },
						-- NormalFloat = { bg = mocha.crust },
						NeoTreeGitUntracked = {
							fg = "#F34141",
						},
						NeoTreeWinSeparator = {
							fg = mocha.crust,
						},
					}
				end,
			},
		})
		vim.cmd("colorscheme catppuccin-mocha")
	end,
}
