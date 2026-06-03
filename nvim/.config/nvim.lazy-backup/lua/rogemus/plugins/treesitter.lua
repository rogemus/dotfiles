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
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "markdown",
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
        tmpl = "gotmpl",
        tpl = "gotmpl",
      },
    })

    vim.treesitter.language.register("gotmpl", "gotmpl")
  end,
}
