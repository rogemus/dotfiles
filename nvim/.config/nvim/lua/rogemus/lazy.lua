local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{
		import = "rogemus.plugins",
	},
	{
		import = "rogemus.plugins.lsp.mason",
	},
}, {
	ui = {
		size = { width = 0.9, height = 0.6 },
		border = "rounded",
	},
})
