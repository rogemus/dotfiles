local devicons = require("nvim-web-devicons")

local utils = require("statusline.utils")

local M = {}

vim.api.nvim_set_hl(0, "StatusLineModeNormal", { fg = "#181825", bg = "#89b4fa", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeNormalB", { fg = "#89b4fa", bg = "#313244", bold = false })
vim.api.nvim_set_hl(0, "StatusLineModeInsert", { fg = "#1e1e2e", bg = "#a6e3a1", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeInsertB", { fg = "#a6e3a1", bg = "#313244", bold = false })
vim.api.nvim_set_hl(0, "StatusLineModeVisual", { fg = "#1e1e2e", bg = "#94e2d5", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeReplace", { fg = "#1e1e2e", bg = "#f38ba8", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeCommand", { fg = "#1e1e2e", bg = "#fab387", bold = true })

local function get_mode()
	local mode_map = {
		["n"] = { text = "NORMAL", hl = "StatusLineModeNormal" },
		["i"] = { text = "INSERT", hl = "StatusLineModeInsert" },
		["v"] = { text = "VISUAL", hl = "StatusLineModeVisual" },
		["V"] = { text = "V-LINE", hl = "StatusLineModeVisual" },
		[""] = { text = "V-BLOCK", hl = "StatusLineModeVisual" }, -- Ctrl+v
		["c"] = { text = "COMMAND", hl = "StatusLineModeCommand" },
		["R"] = { text = "REPLACE", hl = "StatusLineModeReplace" },
		["t"] = { text = "TERMINAL", hl = "StatusLineModeCommand" },
	}
	local current_mode = vim.fn.mode()
	return mode_map[current_mode] or { text = current_mode, hl = "StatusLine" }
end

local function is_git_repo()
	vim.fn.system("git rev-parse --is-inside-work-tree")

	return vim.v.shell_error == 0
end

local function git_diff()
	local file_path = vim.fn.expand("%:p")
	if file_path == "" then
		return ""
	end

	local diff_output = vim.fn.system(string.format("git diff --numstat -- '%s' 2>/dev/null", file_path))
	if vim.v.shell_error ~= 0 then
		return ""
	end

	local added, removed = 0, 0
	for line in diff_output:gmatch("[^\r\n]+") do
		local added_lines, removed_lines = line:match("^(%d+)%s+(%d+)")
		added = added + tonumber(added_lines or 0)
		removed = removed + tonumber(removed_lines or 0)
	end

	local added_str = ""
	local removed_str = ""

	if added > 0 then
		added_str = string.format(" +%d", added)
	end

	if removed > 0 then
		removed_str = string.format(" -%d", removed)
	end

	if added == 0 and removed == 0 then
		return ""
	end

	return string.format("%s%s", added_str, removed_str)
end

local function git_branch(is_in_git_repo)
	if not is_in_git_repo then
		return ""
	end

	local diff = git_diff()
	local cmd_out = vim.fn.system("git branch --show-current")
	local branch = string.gsub(cmd_out, "%s+", "")
	return string.format("%%#StatusLineModeInsertB#  %s%s %%*", branch, diff)
end

local function git_repo_name(is_in_git_repo)
	if not is_in_git_repo then
		return ""
	end

	local result = vim.fn.system("basename `git rev-parse --show-toplevel`")
	local reponame = string.gsub(result, "%s+", "")
	return string.format("%%#StatusLineModeNormalB# %s %%*", reponame)
end

function M.init()
	local mode_info = get_mode()
	local mode = string.format("%%#%s# %s %%*", mode_info.hl, mode_info.text)

	local file_name = vim.fn.expand("%:t")
	local file_ext = vim.fn.expand("%:e")
	local file_modified = vim.bo.modified and " [+]" or ""
	local file_type = vim.bo.filetype

	if file_name == "" then
		file_name = "[No Name]"
	end

	if file_type == "neo-tree" then
		file_name = ""
		file_type = ""
	end

	local icon, icon_color = devicons.get_icon_color(file_name, file_ext, { default = true })
	local icon_highlight = "StatusLineFileIcon"
	vim.api.nvim_set_hl(0, icon_highlight, { fg = icon_color })
	local file_icon = string.format("%%#%s#%s%%*", icon_highlight, icon or "")

	local line = utils.lpad(string.format("%d", vim.fn.line(".")), 2)
	local column = utils.rpad(string.format("%d", vim.fn.col(".")), 2)

	local location = string.format("%%#StatusLineModeInsert# %s:%s %%*", line, column)

	local file = string.format("%s%s", file_name, file_modified)
	local filetype = string.format("%s %s", file_icon, file_type)

	local is_git = is_git_repo()
	local branch = git_branch(is_git)
	local reponame = git_repo_name(is_git)

	local align_right = "%="

	return string.format("%s%s %s  %s %s %s%s", mode, reponame, file, align_right, filetype, branch, location)
end

return M
