local function to_snake(pascal_case_string)
  local snake_case_string = string.gsub(pascal_case_string, "%u", function(c)
    return "_" .. string.lower(c)
  end)

  if string.sub(snake_case_string, 1, 1) == "_" then
    snake_case_string = string.sub(snake_case_string, 2)
  end

  return snake_case_string
end

vim.keymap.set("n", "<leader>js", function()
  local current_line = vim.api.nvim_get_current_line()
  local word = string.match(current_line, "^%s*(%w+)")

  local modified_word = to_snake(word)

  vim.api.nvim_put({}, "l", false, true)

  local fieldTag = ' `json:"' .. modified_word .. '"`'
  local new_line = current_line .. fieldTag

  vim.api.nvim_set_current_line(new_line)
end, { desc = "Add JSON filed tags" })
