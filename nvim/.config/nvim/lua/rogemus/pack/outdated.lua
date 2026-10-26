-- ─── Outdated plugins ─────────────────────────────────────────────
-- :Pack, a floating list of plugins with their status and keys to update them

local actions = require("rogemus.pack.actions")
local check = require("rogemus.pack.check")
local window = require("rogemus.pack.window")

local M = {}

function M.open()
  local plugs = {}
  local rows = {}
  local run = 0

  local function by_name(a, b)
    return a.spec.name < b.spec.name
  end

  -- Placeholder rows from the installed plugins, filled in as the checks finish
  local function load_plugs()
    plugs = vim.pack.get(nil, { info = false })
    table.sort(plugs, by_name)
    rows = {}
    for i, p in ipairs(plugs) do
      rows[i] = { name = p.spec.name, hash = p.rev:sub(1, 7), date = "", status = "checking", remote = "" }
    end
  end

  load_plugs()
  local view = window.open(#rows)

  -- One plugin at a time, a newer run cancels the previous one
  local function check_all()
    run = run + 1
    local id = run
    load_plugs()
    window.render(view, rows)

    local function step(i)
      if id ~= run or not window.is_open(view) or not plugs[i] then
        return
      end
      check.check(plugs[i], function(result)
        if id ~= run then
          return
        end
        rows[i] = result
        window.render(view, rows)
        step(i + 1)
      end)
    end
    step(1)
  end

  local function row_at_cursor()
    return rows[vim.api.nvim_win_get_cursor(view.win)[1] - 1]
  end

  local function update(names)
    if #names == 0 then
      return vim.notify("Nothing to update")
    end
    run = run + 1 -- stop the running checks, they would overwrite the result
    actions.update(names, function(ok, err)
      if not ok then
        vim.notify("Update failed: " .. tostring(err), vim.log.levels.ERROR)
      end
      local fresh = {}
      for _, p in ipairs(vim.pack.get(nil, { info = false })) do
        fresh[p.spec.name] = p.rev:sub(1, 7)
      end
      for _, r in ipairs(rows) do
        if vim.tbl_contains(names, r.name) then
          r.status = ok and "updated" or "failed"
          r.hash = fresh[r.name] or r.hash
        end
      end
      window.render(view, rows)
    end)
  end

  local function map(key, fn)
    vim.keymap.set("n", key, fn, { buffer = view.buf, nowait = true })
  end

  map("u", function()
    local row = row_at_cursor()
    if row and row.status == "outdated" then
      update({ row.name })
    end
  end)

  map("U", function()
    local names = {}
    for _, r in ipairs(rows) do
      if r.status == "outdated" then
        names[#names + 1] = r.name
      end
    end
    update(names)
  end)

  map("c", function()
    local row = row_at_cursor()
    if row then
      actions.changelog(row.name, function()
        if window.is_open(view) then
          check_all()
        end
      end)
    end
  end)

  map("r", check_all)
  map("q", function()
    window.close(view)
  end)
  map("<Esc>", function()
    window.close(view)
  end)

  check_all()
end

return M
