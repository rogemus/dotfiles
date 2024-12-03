local M = {}

function M.run_command(cmd)
	local handle = io.popen(cmd)

	if handle == nil then
		return ""
	end

	local result = handle:read("*a")
	handle:close()
	return result
end

return M
