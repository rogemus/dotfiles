local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  {
    import = "rogemus.plugins",
  },
}, {
  change_detection = {
    enabled = false,
    notify = false,
  },
  ui = {
    size = { width = 0.9, height = 0.6 },
    border = "rounded",
  },
})
