local function repo_name()
	local function is_git_repo()
		vim.fn.system("git rev-parse --is-inside-work-tree")

		return vim.v.shell_error == 0
	end

	if is_git_repo() then
		local result = vim.fn.system("basename `git rev-parse --show-toplevel`")
		return string.gsub(result, "%s+", "")
	end

	return ""
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "catppuccin",
				section_separators = "",
				component_separators = "",
				disabled_filetypes = { "neo-tree" },
				globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { repo_name },
				lualine_c = { "filename" },
				lualine_x = { "diagnostics", "filetype" },
				lualine_y = { "branch", "diff" },
				lualine_z = { "location" },
			},
		})
	end,
}
