vim.keymap.set("n", "<leader>lo", function()
	local word = vim.fn.expand("<cword>")

	if word == "" then
		vim.notify("No word under cursor", vim.log.levels.WARN)
		return
	end

	local line_nr = vim.api.nvim_win_get_cursor(0)[1]
	local console_text = 'console.log("' .. word .. ':", ' .. word .. ");"
	vim.api.nvim_buf_set_lines(0, line_nr, line_nr, false, { console_text })
end, { desc = "Add debug console.log" })
