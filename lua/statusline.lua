local M = {}

-- Create statusline augroup
local statusline_group = vim.api.nvim_create_augroup("StatusLine", { clear = true })

-- Performance optimization: Cache frequently accessed data
local cache = {
  diagnostics = "",
  file_section = "",
  unsaved_buffers = "",
  git_branch = "",
  last_update = 0,
  current_buf = -1,
  current_cwd = "",
}

-- Debouncing timers for performance
local timers = {
  diagnostics = nil,
  redraw = nil,
}

-- LSP Progress tracking
local lsp_progress = {
  client = nil,
  kind = nil,
  title = nil,
  percentage = nil,
  message = nil,
}

-- Debounced diagnostics update for performance
local function update_diagnostics()
  -- Cancel existing timer
  if timers.diagnostics then
    vim.fn.timer_stop(timers.diagnostics)
  end

  -- Debounce diagnostics updates (50ms)
  timers.diagnostics = vim.fn.timer_start(50, function()
    pcall(function()
      local results = {}
      for _, attr in pairs({
        { "Error", "E" },
        { "Warn", "W" },
        { "Hint", "H" },
        { "Info", "I" },
      }) do
        local n = vim.diagnostic.get(0, { severity = attr[1] })
        if #n > 0 then
          table.insert(results, string.format("%s%d ", attr[2], #n))
        end
      end
      cache.diagnostics = table.concat(results)

      -- Trigger redraw with debouncing
      M.schedule_redraw()
    end)
    timers.diagnostics = nil
  end)
end

-- Debounced redraw function
function M.schedule_redraw()
  if timers.redraw then
    vim.fn.timer_stop(timers.redraw)
  end

  timers.redraw = vim.fn.timer_start(10, function()
    pcall(vim.cmd.redrawstatus)
    timers.redraw = nil
  end)
end

-- Check for unsaved buffers with caching
local function unsaved_buffers()
  -- Use cache if buffer hasn't changed
  local current_buf = vim.api.nvim_get_current_buf()
  if cache.current_buf == current_buf and cache.unsaved_buffers ~= "" then
    return cache.unsaved_buffers
  end

  -- Update cache
  cache.current_buf = current_buf

  pcall(function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      -- Use modern API
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified then
        cache.unsaved_buffers = "Unsaved"
        return
      end
    end
    cache.unsaved_buffers = ""
  end)

  return cache.unsaved_buffers
end

-- File section with current file name and caching
local function file_section()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_cwd = vim.fn.getcwd()

  -- Use cache if buffer and cwd haven't changed
  if cache.current_buf == current_buf and cache.current_cwd == current_cwd then
    return cache.file_section
  end

  -- Update cache
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

-- LSP status and progress with error handling
local function lsp_status()
  local result = ""

  pcall(function()
    if not rawget(vim, "lsp") then
      return
    end

    if vim.o.columns < 120 then
      return
    end

    if not lsp_progress.client or not lsp_progress.title then
      return
    end

    local title = lsp_progress.title or ""
    local percentage = (lsp_progress.percentage and (lsp_progress.percentage .. "%%")) or ""
    local message = lsp_progress.message or ""

    local lsp_message = title

    if message ~= "" then
      lsp_message = lsp_message .. " " .. message
    end

    if percentage ~= "" then
      lsp_message = lsp_message .. " " .. percentage
    end

    result = lsp_message .. " "
  end)

  return result
end

-- Git branch information with caching
local function get_branch()
  local current_buf = vim.api.nvim_get_current_buf()

  -- Use cache if buffer hasn't changed
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

-- Main statusline function with performance optimizations
function M.get_statusline()
  -- Build statusline with error protection
  local result = ""

  pcall(function()
    result = file_section()
      .. "%m%r"
      .. unsaved_buffers()
      .. cache.diagnostics -- Use cached diagnostics
      .. lsp_status()
      .. "%="
      .. get_branch()
      .. "%l:%c %L %p%%"
  end)

  return result
end

-- Cache invalidation helper
local function invalidate_cache()
  cache.current_buf = -1
  cache.current_cwd = ""
  cache.file_section = ""
  cache.unsaved_buffers = ""
  cache.git_branch = ""
end

-- Setup function to initialize statusline with performance optimizations
function M.setup()
  pcall(function()
    -- Update diagnostics on relevant events (debounced)
    vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufWinEnter" }, {
      group = statusline_group,
      callback = update_diagnostics,
    })

    -- Handle LSP progress updates with error protection
    vim.api.nvim_create_autocmd("LspProgress", {
      desc = "Update LSP progress in statusline",
      pattern = { "begin", "report", "end" },
      callback = function(args)
        pcall(function()
          if not (args.data and args.data.client_id) then
            return
          end

          lsp_progress = {
            client = vim.lsp.get_client_by_id(args.data.client_id),
            kind = args.data.params.value.kind,
            message = args.data.params.value.message,
            percentage = args.data.params.value.percentage,
            title = args.data.params.value.title,
          }

          if lsp_progress.kind == "end" then
            lsp_progress.title = nil
            vim.defer_fn(function()
              M.schedule_redraw()
            end, 500)
          else
            M.schedule_redraw()
          end
        end)
      end,
    })

    -- Set statusline on window/buffer events with cache invalidation
    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
      group = statusline_group,
      callback = function()
        invalidate_cache()
        vim.wo.statusline = "%!v:lua.require('statusline').get_statusline()"
      end,
    })

    -- Invalidate cache on buffer changes
    vim.api.nvim_create_autocmd({ "BufModifiedSet", "BufWritePost" }, {
      group = statusline_group,
      callback = function()
        cache.unsaved_buffers = "" -- Force recalculation
        M.schedule_redraw()
      end,
    })

    -- Initialize diagnostics
    update_diagnostics()
  end)
end

-- Cleanup function for better resource management
function M.cleanup()
  pcall(function()
    -- Stop any running timers
    if timers.diagnostics then
      vim.fn.timer_stop(timers.diagnostics)
      timers.diagnostics = nil
    end
    if timers.redraw then
      vim.fn.timer_stop(timers.redraw)
      timers.redraw = nil
    end

    -- Clear cache
    invalidate_cache()
  end)
end

return M
