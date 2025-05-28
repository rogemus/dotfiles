-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
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
			"NuiText",
			"ProjectsPrompt",
		}

		local disbaled = vim.tbl_contains(disabled_for, buf_ft) or buf_ft == ""
		if not disbaled and is_modified then
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

