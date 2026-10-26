-- ─── Actions ──────────────────────────────────────────────────────
-- What the keys of the plugin window do

local M = {}

-- Update plugins right away, `on_done(ok, err)`. The UI blocks while git runs
function M.update(names, on_done)
  vim.notify("Updating " .. table.concat(names, ", ") .. "...")
  vim.cmd.redraw()
  local ok, err = pcall(vim.pack.update, names, { force = true })
  on_done(ok, err)
end

-- Open the native confirmation view for one plugin in a new tab, it lists the commits and
-- applies or cancels on :write / :quit. `on_close` runs when that view is closed
function M.changelog(name, on_close)
  vim.api.nvim_create_autocmd("BufWipeout", {
    pattern = "nvim-pack://confirm#*",
    once = true,
    callback = function()
      vim.schedule(on_close)
    end,
  })
  vim.pack.update({ name })
end

return M
