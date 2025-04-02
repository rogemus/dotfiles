return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash",
        "comment",
        "css",
        "diff",
        "dot",
        "git_config",
        "gitignore",
        "go",
        "gosum",
        "gotmpl",
        "gowork",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "query",
        "scss",
        "typescript",
        "vim",
        "vimdoc",
      },
      auto_install = true,
      sync_install = false,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    })

    vim.filetype.add({
      extension = {
        templ = "templ",
      },
    })
    vim.filetype.add({
      extension = {
        tmpl = "gotmpl",
      },
    })

    vim.treesitter.language.register("gotmpl", "gotmpl")
  end,
}
