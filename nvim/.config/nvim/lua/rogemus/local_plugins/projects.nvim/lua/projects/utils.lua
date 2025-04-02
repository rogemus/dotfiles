local state = require("projects.state")

---Print msg in editor
---@param msg string Message
---@param is_error? boolean Check msg color to error
local echo = function(msg, is_error)
  local color = "MoreMsg"

  if is_error == true then
    color = "ErrorMsg"
  end

  vim.api.nvim_echo({ { msg, color } }, false, {})
end

---Get path to project file
---@param project string Project name
---@return string
local get_project_file = function(project)
  local project_dir = state.options.projects_dir
  local project_file = project_dir .. project .. ".json"
  return project_file or ""
end

---Get filename name without extension
---@param filename string Filename with extension
---@return string
local get_filename_without_extension = function(filename)
  return filename:gsub("%.%w+$", "") or filename
end

return {
  echo = echo,
  get_project_file = get_project_file,
  get_filename_without_extension = get_filename_without_extension,
}
