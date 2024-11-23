local keymap = vim.keymap
local g = vim.g
local cmd = vim.cmd

g.mapleader = " "

-- NVim
keymap.set("n", "<leader>pv", cmd.Ex)
keymap.set("v", "K", ":m '<-2<CR>gv=gv")
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("n", "<C-z>", "<Cmd>:u<CR>")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")
keymap.set("n", "<leader>y", '"+y')
keymap.set("v", "<leader>y", '"+y')
keymap.set("n", "<leader>Y", '"+Y')

-- Neotree
keymap.set("n", "<C-]>", "<Cmd>Neotree toggle<CR>")

-- Split pane
keymap.set("n", "<C-w>", "<C-w><C-w>") -- Next
keymap.set("n", "<C-h>", "<Cmd>wincmd h<CR>") -- Next to left
keymap.set("n", "<C-j>", "<Cmd>wincmd j<CR>") -- Next to bottom
keymap.set("n", "<C-k>", "<Cmd>wincmd k<CR>") -- Next to top
keymap.set("n", "<C-l>", "<Cmd>wincmd l<CR>") -- Next to right

-- Tabs
keymap.set("n", "<C-!>", "<Cmd>tabn 1<CR>") -- Go to tab 1
keymap.set("n", "<C-@>", "<Cmd>tabn 2<CR>") -- Go to tab 2
keymap.set("n", "<C-#>", "<Cmd>tabn 3<CR>") -- Go to tab 3
keymap.set("n", "<C-$>", "<Cmd>tabn 4<CR>") -- Go to tab 4
keymap.set("n", "<C-%>", "<Cmd>tabn 5<CR>") -- Go to tab 5
keymap.set("n", "<C-^>", "<Cmd>tabn 6<CR>") -- Go to tab 6
keymap.set("n", "<C-&>", "<Cmd>tabn 7<CR>") -- Go to tab 7
keymap.set("n", "<C-*>", "<Cmd>tabn 8<CR>") -- Go to tab 8
keymap.set("n", "<C-(>", "<Cmd>tabn 9<CR>") -- Go to tab 9
keymap.set("n", "<C-)>", "<Cmd>tabn 10<CR>") -- Go to tab 10

keymap.set("n", "]t", "<Cmd>tabnext<CR>", { desc = "Go to next tab" })
keymap.set("n", "[t", "<Cmd>tabprev<CR>", { desc = "Go to prev tab" })
keymap.set("n", "]T", "<Cmd>tabfir<CR>", { desc = "Go to first tab" })
keymap.set("n", "]T", "<Cmd>tablast<CR>", { desc = "Go to last tab" })

-- Buffer
keymap.set("n", "bb", "<Cmd>b#<CR>", { desc = "Go to last seen buffer" })
keymap.set("n", "<leader>]", "<Cmd>bnext<CR>", { desc = "Go to next buffer" })
keymap.set("n", "<leader>[", "<Cmd>bprevious<CR>", { desc = "Go to prev buffer" })
keymap.set("n", "<leader>{", "<Cmd>bfirst<CR>", { desc = "Go to first buffer" })
keymap.set("n", "<leader>}", "<Cmd>blast<CR>", { desc = "Go to last buffer" })
keymap.set("n", "<leader>bd", "<Cmd>bdelete<CR>", { desc = "[B]uffer [D]elete (close buffer)" })
keymap.set("n", "<leader>bda", "<Cmd>WipeWindowlessBufs<CR>", { desc = "[B]uffer [D]elete [A]ll (close buffer all)" })
