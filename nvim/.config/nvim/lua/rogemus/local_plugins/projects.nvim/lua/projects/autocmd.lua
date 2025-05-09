local api = require("projects.api")
local state = require("projects.state")

-- Save session on opening new buffer
vim.api.nvim_create_autocmd({ "BufReadPost", "BufDelete" }, {
  desc = "Save project on opening new buffer",
  pattern = "*",
  callback = function()
    vim.schedule(function()
      local current_project = state.current_project

      if current_project ~= "" and state.switching ~= true then
        api.save_project(current_project, false)
      end
    end)
  end,
})
