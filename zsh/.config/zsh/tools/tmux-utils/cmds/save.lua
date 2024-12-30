local session_file = require("../config/paths").session_file
local run_command = require("../utils/cmd").run_command

local M = {}

function M.save_session()
	local answer

	repeat
		io.write("Save current session to file .tmux-session (y/n)? ")
		io.flush()
		answer = io.read()
	until answer == "y" or answer == "n"

	if answer == "n" then
		os.exit()
	end

	local file = io.open(session_file, "w")

	if not file then
		print("Failed to open file for writing: " .. session_file)
		return
	end

	local sessions = run_command("tmux list-sessions -F '#{session_name}'")
	for session in string.gmatch(sessions, "[^\n]+") do
		file:write("session " .. session .. "\n")

		local windows =
			run_command("tmux list-windows -t " .. session .. " -F '#{window_index} #{window_name} #{window_layout}'")
		for window_line in string.gmatch(windows, "[^\n]+") do
			local window_index, window_name, window_layout = string.match(window_line, "(%S+) (%S+) (%S+)")
			file:write("window " .. window_index .. " " .. window_name .. "\n")

			local panes = run_command(
				"tmux list-panes -t "
					.. session
					.. ":"
					.. window_index
					.. " -F '#{pane_index} #{pane_title} #{pane_current_path}'"
			)
			for pane_line in string.gmatch(panes, "[^\n]+") do
				file:write("pane " .. pane_line .. "\n")
			end

			file:write("layout " .. window_index .. " " .. window_layout .. "\n")
		end

		file:write("\n")
	end

	file:close()
	print("Tmux session saved to: " .. session_file)
end

return M
