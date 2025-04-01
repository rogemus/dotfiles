local state = require("projects.state")
local utils = require("projects.utils")
local json = require("projects.json")
local cwd = require("projects.cwd")

---@class Buffer
---@field path string Buffer path
---@field column number Cursor column position in buffer
---@field line number Cursor line position in buffer

---@class Project
---@field project string Project Name
---@field cwd string Project Path
---@field current_win number current window
---@field current_tab integer current tab
---@field buffers Buffer[] Open buffers in session

---Delete project
---@param project string Project name
local delete_project = function(project)
	if project == nil or project == "" then
		utils.echo("Invalid project. Cannot delete project", true)
		return
	end

	local project_file = utils.get_project_file(project)
	local result = vim.fn.delete(project_file)

	if result == 0 then
		utils.echo("Successfully deleted project: " .. project)
		return
	end

	utils.echo("Failed to delete project " .. project, true)
end

---Save project to file
---@param project string Project name
local save_project = function(project)
	if project == nil or project == "" then
		utils.echo("Invalid project name. Cannot save project.", true)
		return
	end

	local project_file = utils.get_project_file(project)
	os.execute("mkdir -p " .. state.options.projects_dir)

	---@type Buffer[]
	local buffers = {}
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_get_option_value("buflisted", { buf = buf }) then
			local buffer_name = vim.api.nvim_buf_get_name(buf)

			if buffer_name ~= "" then
				local win_for_buffer = vim.fn.bufwinid(buf)
				local cursor_pos = { 1, 0 }

				if win_for_buffer ~= -1 then
					cursor_pos = vim.api.nvim_win_get_cursor(win_for_buffer)
				end

				---@type Buffer
				local buffer = {
					path = buffer_name,
					line = cursor_pos[1],
					column = cursor_pos[2],
				}

				table.insert(buffers, buffer)
			end
		end
	end

	local current_tab = vim.api.nvim_get_current_tabpage()
	local current_win = vim.api.nvim_get_current_win()
	local project_cwd = cwd.get_root()

	if project_cwd == "" then
		utils.echo("Invalid root. .git directory not found.", true)
		return
	end

	---@type Project
	local project_data = {
		project = project,
		buffers = buffers,
		current_tab = current_tab,
		current_win = current_win,
		cwd = project_cwd,
	}

	json.save_json(project_file, project_data)
end

---Change editor path to session project
---@param project_name string
---@param project_path string
local cd_project = function(project_name, project_path)
	local last_project = state.current_project

	state.current_project = project_name
	state.last_project = last_project

	vim.cmd("cd " .. project_path)
end

---Restore all buffers from session
---@param buffers Buffer[]
local restore_buffers = function(buffers)
	for i = #buffers, 1, -1 do
		local buf_info = buffers[i]

		vim.cmd("edit " .. buf_info.path)

		-- Set cursor position
		if buf_info.line and buf_info.column then
			local current_buf = vim.api.nvim_get_current_buf()
			local win = vim.fn.bufwinid(current_buf)
			if win ~= -1 then
				vim.api.nvim_win_set_cursor(win, { buf_info.line, buf_info.column })
			end
		end
	end
end

---Close all buffers in current session
local close_all_buffers = function()
	vim.cmd("silent! %bdelete!")
end

---Restore project
---@param project Project
local restore_project = function(project)
	cd_project(project.project, project.cwd)
	close_all_buffers()
	restore_buffers(project.buffers)
end

--- Get all projects files
local get_projects = function()
	local files = vim.fn.readdir(state.options.projects_dir)

	return files
end

---Load project json
---@param project string Project name
---@return Project
local load_project = function(project)
	local project_file = utils.get_project_file(project)
	local project_data = json.read_json(project_file)
	return project_data
end

---Switch project and restore session
---@param project { name: string, file: string } Project name
local switch_project = function(project)
	---Save current project
	if state.current_project ~= nil and state.current_project ~= "" then
		save_project(state.current_project)
	end

	local project_data = load_project(project.name)
	restore_project(project_data)
end

---Create new project
---@param project_name string Name of the new project
local create_project = function(project_name)
	local name = project_name or "default"
	save_project(name)
end

return {
	cd_project = cd_project,
	close_all_buffers = close_all_buffers,
	get_projects = get_projects,
	init_session = restore_project,
	restore_buffers = restore_buffers,
	save_project = save_project,
	switch_project = switch_project,
	create_project = create_project,
  delete_project = delete_project
}
