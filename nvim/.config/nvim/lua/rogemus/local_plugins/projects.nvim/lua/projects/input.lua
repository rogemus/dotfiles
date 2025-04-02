local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local M = {}

---Setup input
---@param on_submit_action function On submit action
function M.setup(on_submit_action)
  M.input = Input({
    prompt = "ProjectsPrompt",
    position = "50%",
    size = {
      width = 40,
    },
    border = {
      style = "single",
      text = {
        top = "[Project Name]",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    prompt = "> ",
    default_value = "",
    on_submit = on_submit_action,
  })

  return M
end

---Open Input
function M.open()
  M.input:mount()

  M.input:map("n", "<Esc>", function()
    M.input:unmount()
  end, { noremap = true })

  M.input:map("n", "q", function()
    M.input:unmount()
  end, { noremap = true })
end

---Close Input
function M.close()
  M.input:on(event.BufLeave, function()
    M.input:unmount()
  end)
end

return M
