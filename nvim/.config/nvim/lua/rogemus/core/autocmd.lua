-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Auto save files after edit
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	pattern = "*",
	desc = "Auto save files after edit",
	callback = function()
		local buf_ft = vim.api.nvim_get_option_value("filetype", {})
		local is_modified = vim.api.nvim_get_option_value("modified", {})

		local disabled_for = {
			"Telescope",
			"TelescopeResults",
			"TelescopePrompt",
			"NeoTree",
			"neo-tree-popup",
			"neo-tree",
		}

		if not vim.tbl_contains(disabled_for, buf_ft) and is_modified then
			local time = os.date("%H:%M:%S")
			local filename = vim.fn.expand("%:t")

			vim.cmd("silent! write")
			vim.api.nvim_echo({ { "Auto-saved at " .. time .. ": " .. filename, "MoreMsg" } }, false, {})

			-- Clear message after 1 s
			vim.defer_fn(function()
				vim.api.nvim_echo({ { "", "" } }, false, {})
			end, 1000)
		end
	end,
})

--Close all buffers
vim.api.nvim_create_user_command("WipeWindowlessBufs", function()
	local bufinfos = vim.fn.getbufinfo({ buflisted = true })
	vim.tbl_map(function(bufinfo)
		if bufinfo.changed == 0 and (not bufinfo.windows or #bufinfo.windows == 0) then
			print(("Deleting buffer %d : %s"):format(bufinfo.bufnr, bufinfo.name))
			vim.api.nvim_buf_delete(bufinfo.bufnr, { force = false, unload = false })
		end
	end, bufinfos)
end, { desc = "Wipeout all buffers not shown in a window" })
