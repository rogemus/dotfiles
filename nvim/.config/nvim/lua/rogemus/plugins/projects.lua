return {
	dir = "~/.config/nvim/lua/rogemus/local_plugins/projects.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"MunifTanjim/nui.nvim",
	},
	init = function()
		local projects = require("projects")

		vim.keymap.set("n", "<leader>pS", projects.save_project, { desc = "Save project" })
		vim.keymap.set("n", "<leader>ps", projects.select_project, { desc = "Switch project" })
		vim.keymap.set("n", "<leader>pn", projects.create_project, { desc = "Create new project" })
	end,
}
