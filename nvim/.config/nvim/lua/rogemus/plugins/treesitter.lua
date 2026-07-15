-- Neovim 0.12+ has built-in treesitter support
-- Syntax highlighting is enabled by default
-- The nvim-treesitter plugin has been archived and is no longer needed

-- Enable highlighting + indentation for every filetype
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Install parsers on startup (skips already-installed ones)
local want = { "lua", "python", "javascript", "typescript", "bash" }
vim.defer_fn(function()
  local ok, ts = pcall(require, "nvim-treesitter")
  if not ok then
    return
  end
  local have = require("nvim-treesitter.config").get_installed()
  local missing = vim
    .iter(want)
    :filter(function(p)
      return not vim.tbl_contains(have, p)
    end)
    :totable()
  if #missing > 0 then
    ts.install(missing)
  end
end, 100)
