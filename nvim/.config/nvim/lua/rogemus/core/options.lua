-- Mouse
vim.opt.mouse = "a"

-- Line Number
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10

-- Whitespaces
vim.opt.listchars = {
	space = "·",
	-- tab = ">_",
	tab = "⇾ ",
}
vim.opt.list = true

-- Tab size
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.showmode = false

vim.opt.wrap = false
vim.opt.updatetime = 50

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.go.ignorecase = true

-- Python
vim.g.python3_host_prog = "/Users/kacper.rogowski/.pyenv/versions/py3nvim/bin/python"
