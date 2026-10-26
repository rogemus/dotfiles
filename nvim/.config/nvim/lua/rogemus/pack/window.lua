-- ─── Floating window ──────────────────────────────────────────────
-- Draws the plugin list. Rows are { name, hash, date, status, remote }

local M = {}

local ns = vim.api.nvim_create_namespace("rogemus_pack")
local HINT = " u update  U update all  c changelog  r refresh  q close"

local STATUS = {
  checking = { text = "checking...", hl = "Comment" },
  ok = { text = "up to date", hl = "DiagnosticOk" },
  outdated = { text = "outdated", hl = "DiagnosticWarn" },
  updated = { text = "updated, restart nvim", hl = "DiagnosticInfo" },
  failed = { text = "update failed", hl = "DiagnosticError" },
  unknown = { text = "unknown", hl = "Comment" },
}

-- Open a centred float with room for `count` rows, returns { buf, win }
function M.open(count)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "pack-outdated"

  local width = math.min(90, vim.o.columns - 4)
  local height = math.min(count + 3, vim.o.lines - 6)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Plugins ",
    title_pos = "center",
  })
  vim.wo[win].cursorline = true
  return { buf = buf, win = win }
end

function M.is_open(view)
  return vim.api.nvim_win_is_valid(view.win)
end

function M.close(view)
  if M.is_open(view) then
    vim.api.nvim_win_close(view.win, true)
  end
end

-- Redraw the whole list. Line 0 is the header, row `i` is on line `i`
function M.render(view, rows)
  if not vim.api.nvim_buf_is_valid(view.buf) then
    return
  end

  local name_w = #"PLUGIN"
  for _, r in ipairs(rows) do
    name_w = math.max(name_w, #r.name)
  end
  local fmt = " %-" .. name_w .. "s  %-7s  %-10s  %s"
  local status_col = name_w + 24

  local lines = { fmt:format("PLUGIN", "COMMIT", "DATE", "STATUS") }
  for _, r in ipairs(rows) do
    local status = STATUS[r.status] or STATUS.unknown
    local text = status.text
    if r.status == "outdated" and r.remote ~= "" then
      text = text .. "  ->  " .. r.remote
    end
    lines[#lines + 1] = fmt:format(r.name, r.hash, r.date, text)
  end
  lines[#lines + 1] = ""
  lines[#lines + 1] = HINT

  vim.bo[view.buf].modifiable = true
  vim.api.nvim_buf_set_lines(view.buf, 0, -1, false, lines)
  vim.bo[view.buf].modifiable = false

  vim.api.nvim_buf_clear_namespace(view.buf, ns, 0, -1)
  vim.api.nvim_buf_set_extmark(view.buf, ns, 0, 0, { end_col = #lines[1], hl_group = "Title" })
  for i, r in ipairs(rows) do
    local status = STATUS[r.status] or STATUS.unknown
    vim.api.nvim_buf_set_extmark(view.buf, ns, i, status_col, { end_col = #lines[i + 1], hl_group = status.hl })
  end
  vim.api.nvim_buf_set_extmark(view.buf, ns, #lines - 1, 0, { end_col = #lines[#lines], hl_group = "Comment" })
end

return M
