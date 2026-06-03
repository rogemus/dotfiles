return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "catppuccin",
        section_separators = "",
        component_separators = "",
        disabled_filetypes = { "neo-tree" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_c = { "filename" },
        lualine_x = { "diagnostics", "filetype" },
        lualine_y = { "branch", "diff" },
        lualine_z = { "location" },
      },
    })
  end,
}
