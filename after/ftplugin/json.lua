-- <leader>J: Replace buffer with clipboard content and format JSON
vim.keymap.set("n", "<leader>J", function()
  vim.cmd([[
    silent! %delete _
    silent! normal! "+p
    silent! %!jq .
  ]])
  vim.notify("Pasted and formatted with jq", vim.log.levels.INFO)
end, {
  buffer = true,
  desc = "Replace buffer with clipboard JSON and format",
  silent = true,
})

-- <leader>ju: Unescape JSON string and format it
vim.keymap.set("n", "<leader>ju", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")

  local is_escaped = content:match('^%s*"') and (content:match('\\"') or content:match('\\n'))

  if not is_escaped then
    vim.notify("Content doesn't look like escaped JSON. Proceeding anyway...", vim.log.levels.WARN)
  end

  local result = vim.fn.system("echo " .. vim.fn.shellescape(content) .. " | jq -r . | jq . 2>&1")
  local exit_code = vim.v.shell_error

  local has_error = result:match("jq: parse error:") or result:match("jq: error:")

  if exit_code == 0 and not has_error then
    -- Success - replace buffer content
    vim.cmd("silent! %delete _")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result, "\n"))
    vim.notify("Unescaped and formatted JSON", vim.log.levels.INFO)
  else
    -- Failed - try simple unescape as fallback
    local error_msg = result:match("jq: parse error: (.+)") or result:match("jq: error: (.+)") or "Failed to parse"
    error_msg = error_msg:gsub("\n", " "):gsub("%s+", " ") -- Clean up error message

    local unescaped = content
        :gsub('^%s*"', '')  -- Remove leading quote
        :gsub('"%s*$', '')  -- Remove trailing quote
        :gsub('\\"', '"')   -- Unescape quotes
        :gsub('\\n', '\n')  -- Unescape newlines
        :gsub('\\t', '\t')  -- Unescape tabs
        :gsub('\\r', '\r')  -- Unescape carriage returns
        :gsub('\\\\', '\\') -- Unescape backslashes (must be last!)

    local format_result = vim.fn.system("echo " .. vim.fn.shellescape(unescaped) .. " | jq . 2>&1")
    local format_exit = vim.v.shell_error
    local format_has_error = format_result:match("jq: parse error:") or format_result:match("jq: error:")

    if format_exit == 0 and not format_has_error then
      vim.cmd("silent! %delete _")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(format_result, "\n"))
      vim.notify("Unescaped and formatted (fallback method)", vim.log.levels.INFO)
    else
      vim.cmd("silent! %delete _")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(unescaped, "\n"))
      vim.notify("Unescaped only (couldn't format - invalid JSON?)", vim.log.levels.WARN)
    end
  end
end, {
  buffer = true,
  desc = "Unescape JSON string and format",
  silent = true,
})

-- <leader>jc: Compact/minify JSON
vim.keymap.set("n", "<leader>jc", function()
  vim.cmd("silent! %!jq -c .")
  vim.notify("Compacted JSON with jq", vim.log.levels.INFO)
end, {
  buffer = true,
  desc = "Compact/minify JSON",
  silent = true,
})
