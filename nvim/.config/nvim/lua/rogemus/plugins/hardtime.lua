return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {},
	config = function()
		require("hardtime").setup({ disable_mouse = false })
	end,
}
