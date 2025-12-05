local run_command = require("../utils/cmd").run_command

local M = {}

function M.attach_session()
	local session_name = run_command("tmux ls | fzf --height 20% --border top | awk '{print $1}' | sed 's/://g'")

	if session_name == "" then
		os.exit()
	end

	run_command("tmux attach -t " .. session_name)
end

return M
