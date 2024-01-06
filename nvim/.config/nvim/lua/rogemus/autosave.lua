local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

api.nvim_create_augroup("AutoSave", {})
api.nvim_create_autocmd(
  { "InsertLeave", "TextChanged" },
  {
    pattern = "*",
    callback = function()
      local buf = buf or api.nvim_get_current_buf()

      if not api.nvim_buf_get_option(buf, "modified") then
        return
      end

      local time = os.date("%H:%M:%S")
      local filename = fn.expand('%:t')

      -- local filename = api.nvim_buf_get_name(0)
      local msg = string.format("AutoSave (%s): saved at %s", filename, time)

      api.nvim_echo({ { msg, "MsgArea" } }, true, {})
      api.nvim_buf_call(buf, function()
        cmd("silent! write")
      end)
      fn.timer_start(1500, function()
        cmd([[echon '']])
      end)
    end
  }
)
