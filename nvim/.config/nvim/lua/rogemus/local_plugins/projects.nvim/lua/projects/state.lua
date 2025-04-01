local M = {}

M = {
	last_project = "",
	current_project = "",
}

M.options = {
	projects_dir = vim.fn.stdpath("config") .. "/_projects/",
}

return M
