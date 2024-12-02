M = {}

function M.rpad(str, length, char)
	char = char or " " -- Default padding character is a space
	local str_len = #str
	if str_len >= length then
		return str -- No padding needed
	end
	return str .. string.rep(char, length - str_len)
end

function M.lpad(str, length, char)
	char = char or " " -- Default padding character is a space
	local str_len = #str
	if str_len >= length then
		return str -- No padding needed
	end
	return string.rep(char, length - str_len) .. str
end

return M
