local state = require("projects.state")

---@param msg string
---Print msg in editor
local echo = function(msg)
	vim.api.nvim_echo({ { msg } }, false, {})
end

---@param project string Project name
---@return string
---Get path to project file
local get_project_file = function(project)
	local project_dir = state.options.projects_dir
	local project_file = project_dir .. project .. ".json"
	return project_file or ""
end

---@param filename string Filename with extension
---@return string
---Get filename name without extension
local get_filename_without_extension = function(filename)
	return filename:gsub("%.%w+$", "") or filename
end

return {
	echo = echo,
	get_project_file = get_project_file,
	get_filename_without_extension = get_filename_without_extension,
}
