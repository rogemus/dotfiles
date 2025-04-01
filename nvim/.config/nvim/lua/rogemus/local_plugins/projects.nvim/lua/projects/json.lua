local utils = require("projects.utils")

---@param path string
---@param data any
local save_json = function(path, data)
	local json_str = vim.fn.json_encode(data)

	local file = io.open(path, "w")
	if file then
		file:write(json_str)
		file:close()
		utils.echo("Project saved to: " .. path)
	else
		utils.echo("Failed to write project to: " .. path, true)
	end
end

---@param path string
---@return string|nil
local read_json = function(path)
	if vim.fn.filereadable(path) == 0 then
		return nil
	end

	local file = io.open(path, "r")
	if not file then
		return nil
	end

	local content = file:read("*all")
	file:close()

	local ok, session_data = pcall(vim.fn.json_decode, content)
	if not ok or not session_data then
		return nil
	end

	return session_data
end

return {
	read_json = read_json,
	save_json = save_json,
}
