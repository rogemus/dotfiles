local flags = require("../config/flags")

local M = {}

function M.help()
	print("Usage: [options]")
	print("   " .. table.concat(flags.help_flags, " ") .. "       Display help information")
	print("   " .. table.concat(flags.save_flags, " ") .. "       Save tmux sessions")
	print("   " .. table.concat(flags.restore_flags, " ") .. "    Restore tmux session")
	print("   " .. table.concat(flags.attach_flags, " ") .. "     Attach to tmux session")
end

return M
