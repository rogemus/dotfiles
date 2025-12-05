return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavor = "mocha",
      background = {
        light = "mocha",
        dark = "mocha",
      },

      integrations = {
        neotree = true,
        gitgutter = true,
        treesitter = true,
        native_lsp = {
          enabled = true,
          inlay_hints = { background = true },
        },
        blink_cmp = true,
      },

      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#000000",
          crust = "#1a1a1a",
        },
      },

      highlight_overrides = {
        mocha = function(mocha)
          return {
            Whitespace = { fg = "#2e2e2e" },
            Pmenu = { bg = mocha.crust },
            NormalNC = { bg = mocha.base },
            NeoTreeGitUntracked = {
              fg = "#e24852",
            },
            LineNr = {
              fg = mocha.peach,
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

    vim.cmd.colorscheme("catppuccin")
  end,
}
