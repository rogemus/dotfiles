-- ─── Plugin status ────────────────────────────────────────────────
-- Compares the revision of an installed plugin with what its remote offers,
-- following the `version` of its vim.pack spec (nothing, a branch or tag, or a range)

local M = {}

-- Run git without blocking, `on_done` gets stdout or nil on failure
local function git(args, cwd, on_done)
  vim.system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }, function(res)
    vim.schedule(function()
      on_done(res.code == 0 and res.stdout or nil)
    end)
  end)
end

-- Parse `git ls-remote` output into { sha, ref } entries.
-- Annotated tags list the commit on a second `^{}` line, which replaces the tag object
local function parse_refs(out)
  local refs, peeled = {}, {}
  for line in vim.gsplit(out, "\n", { plain = true, trimempty = true }) do
    local sha, ref = line:match("^(%x+)%s+(.+)$")
    if sha and ref:sub(-3) == "^{}" then
      peeled[ref:sub(1, -4)] = sha
    elseif sha then
      refs[#refs + 1] = { sha = sha, ref = ref }
    end
  end
  for _, r in ipairs(refs) do
    r.sha = peeled[r.ref] or r.sha
  end
  return refs
end

-- Revision the remote offers for this spec, nil when it can't be resolved
local function resolve_target(spec, path, on_done)
  local version = spec.version

  -- Range: newest tag inside it
  if type(version) == "table" then
    git({ "ls-remote", "--tags", "origin" }, path, function(out)
      if not out then
        return on_done(nil)
      end
      local best, best_sha
      for _, r in ipairs(parse_refs(out)) do
        local tag = r.ref:match("^refs/tags/(.+)$")
        local parsed = tag and vim.version.parse(tag)
        if parsed and version:has(parsed) and (not best or vim.version.gt(parsed, best)) then
          best, best_sha = parsed, r.sha
        end
      end
      on_done(best_sha)
    end)
    return
  end

  -- Branch or tag name, or the default branch
  local refspecs = { "HEAD" }
  if type(version) == "string" then
    refspecs = { "refs/heads/" .. version, "refs/tags/" .. version, "refs/tags/" .. version .. "^{}" }
  end
  git(vim.list_extend({ "ls-remote", "origin" }, refspecs), path, function(out)
    local refs = out and parse_refs(out)
    on_done(refs and refs[1] and refs[1].sha or nil)
  end)
end

-- Check one plugin from vim.pack.get(). `on_done` gets
-- { name, hash, date, status = "ok" | "outdated" | "unknown", remote }
function M.check(plug, on_done)
  local result = { name = plug.spec.name, hash = plug.rev:sub(1, 7), date = "", status = "unknown", remote = "" }
  git({ "log", "-1", "--format=%cs", plug.rev }, plug.path, function(date)
    result.date = date and vim.trim(date) or ""
    resolve_target(plug.spec, plug.path, function(sha)
      if sha and sha == plug.rev then
        result.status = "ok"
      elseif sha then
        result.status = "outdated"
        result.remote = sha:sub(1, 7)
      end
      on_done(result)
    end)
  end)
end

return M
