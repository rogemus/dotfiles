local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local themes = require("telescope.themes")
local utils = require("projects.utils")

---Open Telescope picker with Projects
---@param projects_files string[] Project files
---@param action function On select action
local open = function(projects_files, action)
	local projects = {}

	for _, file in ipairs(projects_files) do
		table.insert(projects, {
			name = utils.get_filename_without_extension(file),
			file = file,
		})
	end

	pickers
		.new(themes.get_dropdown(), {
			prompt_title = "Projects",
			finder = finders.new_table({
				results = projects,
				entry_maker = function(entry)
					local project = entry
					return {
						value = project,
						display = project.name,
						ordinal = project.file,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					action(selection)
				end)
				return true
			end,
		})
		:find()
end

return { open = open }
