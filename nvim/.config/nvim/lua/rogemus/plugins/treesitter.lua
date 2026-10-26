-- ─── Highlight and indent ─────────────────────────────────────────
-- Enabled for every filetype
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- ─── Parsers ──────────────────────────────────────────────────────
-- Installed on startup, skipping ones already installed
local want = {
  "bash",
  "css",
  "comment",
  "go",
  "groovy",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "json5",
  "just",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "python",
  "python",
  "robot",
  "templ",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "xml",
  "yaml",
  "zsh",
}
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

-- ─── MDX filetype ─────────────────────────────────────────────────
vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})

vim.treesitter.language.register("markdown", "mdx")
