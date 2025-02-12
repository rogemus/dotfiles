return {
	"nvim-tree/nvim-web-devicons",
	event = "VeryLazy",
	config = function()
		local devicons = require("nvim-web-devicons")
		devicons.setup()
	end,
}
