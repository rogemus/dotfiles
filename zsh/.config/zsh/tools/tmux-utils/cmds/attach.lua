local run_command = require("../utils/cmd").run_command

local M = {}

function M.attach_session()
	-- SESSION_NAME="$(tmux ls | fzf | awk '{print $1}' | sed 's/://g')"
	-- tmux attach -t ${SESSION_NAME}

	local session_name = run_command("tmux ls | fzf | awk '{print $1}' | sed 's/://g'")
	run_command("tmux attach -t " .. session_name)
end

return M
