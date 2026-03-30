local M = {}

local statusline_group = vim.api.nvim_create_augroup("StatusLine", { clear = true })

local cache = {
  file_section = "",
  git_branch = "",
  current_buf = -1,
  current_cwd = "",
}

local function unsaved_buffers()
  local result = ""
  pcall(function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified then
        result = " Unsaved "
        return
      end
    end
  end)
  return result
end

local function file_section()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_cwd = vim.fn.getcwd()

  if cache.current_buf == current_buf and cache.current_cwd == current_cwd and cache.file_section ~= "" then
    return cache.file_section
  end

  cache.current_buf = current_buf
  cache.current_cwd = current_cwd

  local name = ""
  pcall(function()
    local expand_result = vim.fn.expand("%:.")
    name = (expand_result == "") and "No Name" or expand_result
  end)

  cache.file_section = string.format("%s ", name)
  return cache.file_section
end

local function get_branch()
  local current_buf = vim.api.nvim_get_current_buf()
  if cache.current_buf == current_buf and cache.git_branch ~= "" then
    return cache.git_branch
  end

  local result = ""
  pcall(function()
    local branch = vim.b.gitsigns_head
    if branch and branch ~= "" then
      result = string.format("%s ", branch)
    end
  end)

  cache.git_branch = result
  return result
end

function M.get_statusline()
  local result = ""
  pcall(function()
    local diag = vim.diagnostic.status() or ""
    local progress = vim.ui.progress_status() or ""
    if diag ~= "" then
      diag = diag .. " "
    end
    if progress ~= "" then
      progress = progress .. " "
    end

    result = file_section()
      .. "%m%r"
      .. unsaved_buffers()
      .. diag
      .. progress
      .. "%="
      .. get_branch()
      .. "%l:%c %L %p%%"
  end)
  return result
end

local function invalidate_cache()
  cache.current_buf = -1
  cache.current_cwd = ""
  cache.file_section = ""
  cache.git_branch = ""
end

function M.setup()
  pcall(function()
    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
      group = statusline_group,
      callback = function()
        invalidate_cache()
        vim.wo.statusline = "%!v:lua.require('statusline').get_statusline()"
      end,
    })

    vim.api.nvim_create_autocmd({ "BufModifiedSet", "BufWritePost", "FocusGained" }, {
      group = statusline_group,
      callback = function()
        cache.git_branch = ""
        pcall(vim.cmd.redrawstatus)
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = statusline_group,
      pattern = "GitSignsUpdate",
      callback = function()
        cache.git_branch = ""
        pcall(vim.cmd.redrawstatus)
      end,
    })
  end)
end

return M
