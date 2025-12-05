local help_cmd = require("./cmds/help")
local attach_cmd = require("./cmds/attach")
local save_cmd = require("./cmds/save")
local restore_cmd = require("./cmds/restore")

local table_utils = require("./utils/table")
local flags = require("./config/flags")

local includes = table_utils.includes
local cmds = {
	help_cmd = help_cmd,
	save_cmd = save_cmd,
	attach_cmd = attach_cmd,
	restore_cmd = restore_cmd,
}

M = {}

function M.init()
	local action = arg[1]

	if includes(flags.save_flags, action) then
		cmds.save_cmd.save_session()
	elseif includes(flags.restore_flags, action) then
		cmds.restore_cmd.restore_session()
	elseif includes(flags.attach_flags, action) then
		cmds.attach_cmd.attach_session()
	elseif includes(flags.help_flags, action) then
		cmds.help_cmd.help()
	else
		cmds.help_cmd.help()
	end
end

return M
