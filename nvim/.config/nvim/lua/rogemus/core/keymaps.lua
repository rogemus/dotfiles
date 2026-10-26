-- ─── Search ───────────────────────────────────────────────────────
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- ─── Editing ──────────────────────────────────────────────────────
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected line up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected line down" })
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy selected to clipboard" })

-- ─── Windows ──────────────────────────────────────────────────────
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- ─── Tabs ─────────────────────────────────────────────────────────
vim.keymap.set("n", "]t", "<Cmd>tabnext<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "[t", "<Cmd>tabprev<CR>", { desc = "Go to prev tab" })
vim.keymap.set("n", "[T", "<Cmd>tabfirst<CR>", { desc = "Go to first tab" })
vim.keymap.set("n", "]T", "<Cmd>tablast<CR>", { desc = "Go to last tab" })

-- ─── Buffers ──────────────────────────────────────────────────────
vim.keymap.set("n", "L", "<Cmd>b#<CR>", { desc = "Go to last seen buffer" })
vim.keymap.set("n", "<leader>]", "<Cmd>bnext<CR>", { desc = "Go to next buffer" })
vim.keymap.set("n", "<leader>[", "<Cmd>bprevious<CR>", { desc = "Go to prev buffer" })
vim.keymap.set("n", "<leader>{", "<Cmd>bfirst<CR>", { desc = "Go to first buffer" })
vim.keymap.set("n", "<leader>}", "<Cmd>blast<CR>", { desc = "Go to last buffer" })
vim.keymap.set(
  "n",
  "<leader>bD",
  "<Cmd>WipeBuffers<CR>",
  { desc = "[B]uffer [D]elete [A]ll (close buffer all)" }
)

-- ─── Refresh file ─────────────────────────────────────────────────
vim.keymap.set("n", "<leader>R", "<Cmd>checktime<CR>", { desc = "Update file for external updates" })
-- vim.keymap.set("n", "\\", "<Cmd>Explore<CR>", { desc = "Open files explorer" })

-- ─── Diagnostics ──────────────────────────────────────────────────
-- ]d and [d are nvim defaults
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
