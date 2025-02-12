return {
	"numToStr/Comment.nvim",
	event = "VeryLazy",
	config = function()
		require("Comment").setup({
			-- toggler = {
			--   line = '?',
			-- },
			opleader = {
				line = "?",
			},
		})
	end,
}
