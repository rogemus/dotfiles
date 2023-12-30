local keymap = vim.keymap
local g = vim.g
local api = vim.api
local cmd = vim.cmd
local diagnostic = vim.diagnostic
local l_buf = vim.lsp.buf

g.mapleader = " "
-- NVim
keymap.set("n", "<leader>pv", cmd.Ex)
keymap.set("v", "K", ":m '<-2<CR>gv=gv")
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("n", "<C-z>", "<Cmd>:u<CR>")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")
keymap.set("n", "<leader>y", "\"+y")
keymap.set("v", "<leader>y", "\"+y")
keymap.set("n", "<leader>Y", "\"+Y")

-- Neotree
keymap.set("n", "<leader>tt", "<Cmd>Neotree toggle<CR>")

--Split pane
keymap.set("n", "<C-w>", "<C-w><C-w>") -- Next
keymap.set("n", "<C-h>", "<Cmd>wincmd h<CR>") -- Next to left
keymap.set("n", "<C-j>", "<Cmd>wincmd j<CR>") -- Next to bottom
keymap.set("n", "<C-k>", "<Cmd>wincmd k<CR>") -- Next to top
keymap.set("n", "<C-l>", "<Cmd>wincmd l<CR>") -- Next to right

-- LSP
api.nvim_create_autocmd("LspAttach", {
  group = api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }

    keymap.set("n", "<leader>g", l_buf.type_definition)
    keymap.set("n", "<leader>gg", l_buf.definition)
    keymap.set("n", "K", l_buf.hover)
    keymap.set("n", "<leader>vd", diagnostic.open_float)
    keymap.set("n", "[d", diagnostic.goto_prev)
    keymap.set("n", "]d", diagnostic.goto_next)

    keymap.set("n", "<C-f>", function()
      l_buf.format { async = true }
    end, opts)
  end,
})
