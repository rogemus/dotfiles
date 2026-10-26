-- ─── Mouse ────────────────────────────────────────────────────────
vim.opt.mouse = "a"

-- ─── Line numbers and navigation ──────────────────────────────────
vim.opt.number = true -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.scrolloff = 10 -- Keep 10 lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
vim.opt.signcolumn = "yes" -- Always show the sign column, no text shifting

-- ─── Indentation ──────────────────────────────────────────────────
vim.opt.tabstop = 2 -- Tab width
vim.opt.shiftwidth = 2 -- Indent width
vim.opt.softtabstop = 2 -- Soft tab stop
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smart auto-indenting
vim.opt.autoindent = true -- Copy indent from current line

-- ─── Whitespace ───────────────────────────────────────────────────
vim.opt.list = true
vim.opt.listchars = {
  space = "·",
  tab = "⇾ ",
  nbsp = "␣",
}

-- ─── Search ───────────────────────────────────────────────────────
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive if uppercase in search
vim.opt.hlsearch = false -- Don't highlight search results
vim.opt.incsearch = true -- Show matches as you type
vim.opt.inccommand = "split" -- Live preview of :s in a split

-- ─── Files and timing ─────────────────────────────────────────────
-- vim.opt.wrap = false
-- vim.opt.updatetime = 50
vim.opt.swapfile = false

-- ─── Undo history ─────────────────────────────────────────────────
vim.opt.backup = false -- Don't create backup files
vim.opt.writebackup = false -- Don't create backup before writing
vim.opt.undofile = true -- Persistent undo
vim.opt.undolevels = 10000
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undodir") -- Undo directory
vim.opt.updatetime = 300 -- Faster completion
vim.opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
vim.opt.ttimeoutlen = 0 -- Key code timeout
vim.opt.autoread = true -- Auto reload files changed outside vim
vim.opt.autowrite = true -- Auto save

-- ─── Clipboard ────────────────────────────────────────────────────
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- ─── Folding ──────────────────────────────────────────────────────
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

-- ─── Splits ───────────────────────────────────────────────────────
vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right
vim.opt.splitkeep = "screen"

-- ─── Floating windows ─────────────────────────────────────────────
vim.opt.winborder = "rounded"
