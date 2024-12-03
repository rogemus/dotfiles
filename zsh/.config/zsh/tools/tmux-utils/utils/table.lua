local M = {}

function M.includes(t, str)
	for _, value in ipairs(t) do
		if value == str then
			return true
		end
	end
	return false
end

return M
