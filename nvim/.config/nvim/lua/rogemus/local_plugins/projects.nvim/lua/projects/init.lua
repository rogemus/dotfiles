local M = {}

local api = require("projects.api")
local utils = require("projects.utils")
local state = require("projects.state")
local picker = require("projects.picker")
local input = require("projects.input")

---Setup plugin
function M.setup()
	M.project_name_input = input.setup(api.create_project)
end

---Delete current project
function M.delete_project()
	local current_project = state.current_project

	api.delete_project(current_project)
end

---Save current project
function M.save_project()
	local current_project = state.current_project

	api.save_project(current_project)
end

---Load project session
function M.load_project()
	local current_project = state.current_project
	local project_data = api.load_project(current_project)

	if project_data == nil then
		utils.echo("Invalid project: " .. current_project .. ". Cannot load.")
		return
	end

	api.restore_project(project_data)
end

---Open picker to select project
function M.select_project()
	local projects = api.get_projects()

	picker.open(projects, function(project)
		api.switch_project(project)
	end)
end

---Create new project
function M.create_project()
	M.project_name_input.open()
end

return M
