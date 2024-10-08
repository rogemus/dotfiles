local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local function get_project_entries(names, paths)
	local entries = {}
	for key, value in ipairs(names) do
		local project_name = value
		local project_path = paths[key]
		entries[project_name] = project_path
	end

	return entries
end

return {
	"LintaoAmons/cd-project.nvim",
	init = function()
		local api = require("cd-project.api")

		require("cd-project").setup({
			choice_format = "name",
		})

		local dirsPicker = function(opts)
			opts = opts or {
				layout_strategy = "vertical",
				layout_config = { height = 0.35 },
			}

			local project_names = api.get_project_names()
			local project_paths = api.get_project_paths()
			local project_entries = get_project_entries(project_names, project_paths)

			pickers
				.new(opts, {
					prompt_title = "project name",
					finder = finders.new_table({
						results = project_names,
					}),
					sorter = conf.generic_sorter(opts),
					attach_mappings = function(prompt_bufnr, map)
						-- Select project
						actions.select_default:replace(function()
							actions.close(prompt_bufnr)
							local selected = action_state.get_selected_entry()
							local project_name = selected[1]
							local project_path = project_entries[project_name]

							vim.cmd("bufdo bd")
							api.cd_project(project_path)
							vim.notify("Switched to project: " .. project_path, vim.log.levels.INFO)
						end)

						-- Remove project
						map("i", "<C-x>", function()
							local selected = action_state.get_selected_entry()
							local project_name = selected[1]
							local project_path = project_entries[project_name]
							local project_obj = api.build_project_obj(project_path, project_name)

							api.delete_project(project_obj)
							action_state
								.get_current_picker(prompt_bufnr)
								:refresh(
									finders.new_table({ results = api.get_project_names() }),
									{ reset_prompt = true }
								)
						end)

						return true
					end,
				})
				:find()
		end

		local goBack = function()
			local last_project = vim.g.cd_project_last_project
			if not last_project then
				vim.notify("Can't find last project. Haven't switch project yet.")
				return
			end

			vim.cmd("bufdo bd")
			api.cd_project(last_project)
			vim.notify("Switched to project: " .. last_project, vim.log.levels.INFO)
		end

		vim.keymap.set("n", "cb", goBack, { desc = "Switch to prev project" })
		vim.keymap.set("n", "cd", dirsPicker, { desc = "Switch to prev project" })
	end,
}
