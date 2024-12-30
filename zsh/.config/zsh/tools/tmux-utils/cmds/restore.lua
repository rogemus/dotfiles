local session_file = require("../config/paths").session_file
local run_command = require("../utils/cmd").run_command

local M = {}

function M.restore_session()
	local answer

	repeat
		io.write("Restore current session from file .tmux-session (y/n)? ")
		io.flush()
		answer = io.read()
	until answer == "y" or answer == "n"

	if answer == "n" then
		os.exit()
	end

	local file = io.open(session_file, "r")
	if not file then
		print("Failed to open session file: " .. session_file)
		return
	end

	local session_name = nil
	local window_index = nil

	for line in file:lines() do
		local parts = {}
		for part in string.gmatch(line, "%S+") do
			table.insert(parts, part)
		end

		if parts[1] == "session" then
			session_name = parts[2]
			run_command("tmux has-session -t " .. session_name)
			run_command("tmux new-session -d -s" .. session_name)
		elseif parts[1] == "window" then
			window_index = parts[2]
			local window_name = parts[3]

			if window_index ~= "1" then
				run_command("tmux new-window -t " .. session_name .. ":" .. window_index .. " -n " .. window_name)
			end
		elseif parts[1] == "pane" then
			local pane_index = parts[2]
			local pane_title = parts[3]
			local pane_path = parts[4]

			if pane_index ~= "1" then
				run_command("tmux split-window -t " .. session_name .. ":" .. window_index)
			end
			run_command("tmux select-pane -t " .. session_name .. ":" .. window_index .. "." .. pane_index)
			run_command("tmux select-pane -T " .. pane_title)
			run_command(
				"tmux send-keys -t "
					.. session_name
					.. ":"
					.. window_index
					.. "."
					.. pane_index
					.. " 'cd "
					.. pane_path
					.. "' Enter"
			)
			run_command(
				"tmux send-keys -t " .. session_name .. ":" .. window_index .. "." .. pane_index .. " 'clear' Enter"
			)
		elseif parts[1] == "layout" then
			window_index = parts[2]
			local window_layout = parts[3]
			run_command("tmux select-window -t " .. session_name .. ":" .. window_index)
			run_command("tmux select-layout '" .. window_layout .. "'")
		end
	end

	file:close()
	print("Session restored from " .. session_file)
end

return M
