local opt = vim.opt
local cmd = vim.cmd

-- Theme
cmd("colorscheme catppuccin-mocha")

-- Line Number
opt.number = true
opt.relativenumber = true
opt.scrolloff = 10

-- Whitespaces
opt.listchars = {
  space="·",
  tab = ">_",
}
opt.list = true

-- Tab size
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.wrap = false
opt.updatetime = 50

-- Search
opt.hlsearch = false
opt.incsearch = true

-- Gitgutter
-- cmd("GitGutterLineNrHighlightsEnable")
-- cmd("GitGutterLineHighlightsEnable")
