return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      integrations = {
        neotree = true,
        gitgutter = true,
        treesitter = true,
        cmp = true,
        native_lsp = {
          enabled = true,
          inlay_hints = { background = true },
        },
      },
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#000000",
          crust = "#1d1d30",
          -- crust = "#212136",
        },
      },
      highlight_overrides = {
        mocha = function(mocha)
          return {
            Whitespace = { fg = mocha.crust },
            -- Pmenu = { bg = "#a6f578" },
            Pmenu = { bg = mocha.crust },
            -- NormalFloat = { bg = "#0a0a0a" },
            NeoTreeGitUntracked = {
              fg = "#F34141",
            },
            NeoTreeWinSeparator = {
              fg = "#212136",
            },
            LineNr = {
              fg = "#8186a6",
            },
          }
        end,
      },
      custom_highlights = function()
        return {
          LineNrAbove = { fg = "#282828" },
          LineNrBelow = { fg = "#4e4e4e" },
        }
      end,
    })

    local test = "Rwa"

    vim.cmd("colorscheme catppuccin-mocha")
  end,
}
