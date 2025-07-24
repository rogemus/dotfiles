-- Search
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- NeoVim
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected line up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected line down" })
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy selected to clipboard" })

-- Split pane
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "]t", "<Cmd>tabnext<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "[t", "<Cmd>tabprev<CR>", { desc = "Go to prev tab" })
vim.keymap.set("n", "]T", "<Cmd>tabfir<CR>", { desc = "Go to first tab" })
vim.keymap.set("n", "]T", "<Cmd>tablast<CR>", { desc = "Go to last tab" })

-- Buffer
vim.keymap.set("n", "L", "<Cmd>b#<CR>", { desc = "Go to last seen buffer" })
vim.keymap.set("n", "<leader>]", "<Cmd>bnext<CR>", { desc = "Go to next buffer" })
vim.keymap.set("n", "<leader>[", "<Cmd>bprevious<CR>", { desc = "Go to prev buffer" })
vim.keymap.set("n", "<leader>{", "<Cmd>bfirst<CR>", { desc = "Go to first buffer" })
vim.keymap.set("n", "<leader>}", "<Cmd>blast<CR>", { desc = "Go to last buffer" })
vim.keymap.set(
  "n",
  "<leader>bD",
  "<Cmd>WipeWindowlessBufs<CR>",
  { desc = "[B]uffer [D]elete [A]ll (close buffer all)" }
)

-- vim.keymap.set("n", "\\", "<Cmd>Explore<CR>", { desc = "Open files explorer" })
