-- Mouse
vim.opt.mouse = "a"

-- Line Number
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.cursorline = true

-- Whitespaces
vim.opt.list = true
vim.opt.listchars = {
  space = "·",
  -- tab = ">_",
  tab = "⇾ ",
}

-- Tab size
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.showmode = false

-- vim.opt.wrap = false
-- vim.opt.updatetime = 50

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Save undo history
vim.o.undofile = true

--- Clipboard
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- File Explorer
vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30
