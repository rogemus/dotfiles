---Get project root. Directory with `.git` will be treated as root
---@return string
local get_root = function()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir

  if current_file and current_file ~= "" then
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  else
    current_dir = vim.fn.getcwd()
  end

  -- Find git root
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(current_dir) .. " rev-parse --show-toplevel")[1]

  if vim.v.shell_error == 0 and git_root then
    return git_root
  end

  return ""
end

return {
  get_root = get_root,
}
