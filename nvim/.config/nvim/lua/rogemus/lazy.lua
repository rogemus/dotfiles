-- ─── Lazy loading ─────────────────────────────────────────────────
-- Plugins listed in the second vim.pack.add of pack.lua are installed but not on
-- 'runtimepath'. `once` adds them and runs their setup the first time they are needed

local M = {}
local done = {}

-- Run `packadd` for every name and then `setup`, only on the first call per key
function M.once(key, names, setup)
  if done[key] then
    return
  end
  done[key] = true
  for _, name in ipairs(names) do
    vim.cmd.packadd(name)
  end
  if setup then
    setup()
  end
end

-- Define a stub for a plugin command, so typing it by hand loads the plugin first.
-- The stub deletes itself and the plugin defines the real command when it loads
function M.command(name, load)
  vim.api.nvim_create_user_command(name, function(opts)
    pcall(vim.api.nvim_del_user_command, name)
    load()
    vim.cmd(name .. " " .. opts.args)
  end, { nargs = "*" })
end

return M
