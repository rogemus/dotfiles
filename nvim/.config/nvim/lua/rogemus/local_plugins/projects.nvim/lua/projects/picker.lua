local utils = require("projects.utils")
local state = require("projects.state")

---Open FzfLua picker with Projects
---@param projects_files string[] Project files
---@param action function On select action
local open = function(projects_files, action)
  local projects = {}

  for _, file in ipairs(projects_files) do
    local name = utils.get_filename_without_extension(file)
    if name ~= state.current_project then
      table.insert(projects, {
        name = name,
        file = file,
      })
    end
  end

  local fzf_lua = require("fzf-lua")
  fzf_lua.fzf_exec(
    vim.tbl_map(function(p) return p.name end, projects),
    {
      prompt = "Projects> ",
      actions = {
        ['default'] = function(selected)
          local sel_name = selected[1]
          for _, p in ipairs(projects) do
            if p.name == sel_name then
              action(p)
              break
            end
          end
        end,
      },
    }
  )
end

return { open = open }
