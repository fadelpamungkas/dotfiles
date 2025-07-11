local M = {}

-- Marks configuration
local marks_dir = vim.fn.stdpath("state") .. "/marks/"

-- Cache for git branch detection (reuse sessionizer logic)
local cached_branch = nil
local cached_cwd = nil

-- Cache for marks list to avoid repeated file reads
local cached_files = nil
local cache_timestamp = 0
local cache_file_path = nil

-- Get git branch for project-based storage
local function get_git_branch()
  local current_cwd = vim.fn.getcwd()
  if cached_cwd ~= current_cwd then
    cached_cwd = current_cwd
    if vim.fn.isdirectory(current_cwd .. "/.git") == 1 then
      cached_branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
      cached_branch = cached_branch ~= "" and cached_branch or nil
    else
      cached_branch = nil
    end
  end
  return cached_branch
end

-- Generate marks storage file path
local function get_marks_file()
  local cwd = vim.fn.getcwd()
  local full_path = cwd:gsub("^/", ""):gsub("/", "_"):gsub("[^%w_.-]", "")
  local storage_name = full_path

  local branch = get_git_branch()
  if branch then
    storage_name = storage_name .. "_" .. branch:gsub("[^%w_-]", "")
  end

  return marks_dir .. storage_name .. ".json"
end

-- Load marks list from storage with caching
local function load_marks_list()
  local marks_file = get_marks_file()
  local current_time = os.time()

  -- Use cache if valid and file hasn't changed
  if cached_files and cache_file_path == marks_file and (current_time - cache_timestamp) < 5 then
    return cached_files
  end

  -- Load from file
  local files = {}
  if vim.fn.filereadable(marks_file) == 1 then
    local content = vim.fn.readfile(marks_file)
    if #content > 0 then
      local ok, data = pcall(vim.json.decode, table.concat(content, "\n"))
      if ok and data and data.files then
        files = data.files
      end
    end
  end

  -- Update cache
  cached_files = files
  cache_timestamp = current_time
  cache_file_path = marks_file

  return files
end

-- Save marks list to storage and invalidate cache
local function save_marks_list(files)
  local marks_file = get_marks_file()
  local data = {
    files = files,
    cwd = vim.fn.getcwd(),
    timestamp = os.time(),
  }

  vim.fn.mkdir(marks_dir, "p")
  local content = vim.json.encode(data)
  vim.fn.writefile(vim.split(content, "\n"), marks_file)

  -- Update cache immediately
  cached_files = files
  cache_timestamp = os.time()
  cache_file_path = marks_file
end

-- Convert absolute path to relative path for storage
local function to_relative_path(absolute_path)
  local cwd = vim.fn.getcwd()
  if absolute_path:sub(1, #cwd) == cwd then
    return absolute_path:sub(#cwd + 2) -- Remove cwd + "/"
  end
  return absolute_path
end

-- Convert relative path to absolute path for usage
local function to_absolute_path(relative_path)
  if relative_path:sub(1, 1) == "/" then
    return relative_path -- Already absolute
  end
  return vim.fn.getcwd() .. "/" .. relative_path
end

-- Smart path display optimization
local function optimize_paths_display(files)
  if #files <= 1 then
    return files
  end

  -- Find common prefix among all paths
  local paths = {}
  for _, file in ipairs(files) do
    table.insert(paths, vim.fn.fnamemodify(file, ":h"))
  end

  -- Find longest common prefix
  local common_prefix = paths[1]
  for i = 2, #paths do
    local current_prefix = ""
    local min_len = math.min(#common_prefix, #paths[i])

    for j = 1, min_len do
      if common_prefix:sub(j, j) == paths[i]:sub(j, j) then
        current_prefix = current_prefix .. common_prefix:sub(j, j)
      else
        break
      end
    end
    common_prefix = current_prefix
  end

  -- Remove trailing partial directory names
  if common_prefix ~= "" then
    local last_slash = common_prefix:match(".*/()")
    if last_slash then
      common_prefix = common_prefix:sub(1, last_slash - 1)
    end
  end

  -- Return optimized paths
  local optimized = {}
  for _, file in ipairs(files) do
    local dir_path = vim.fn.fnamemodify(file, ":h")
    if common_prefix ~= "" and dir_path:sub(1, #common_prefix) == common_prefix then
      local relative = dir_path:sub(#common_prefix + 1)
      if relative:sub(1, 1) == "/" then
        relative = relative:sub(2)
      end
      optimized[file] = relative == "" and "." or relative
    else
      optimized[file] = dir_path
    end
  end

  return optimized
end

-- Truncate long paths with ellipsis
local function truncate_path(path, max_length)
  if #path <= max_length then
    return path
  end

  -- Truncate middle with ellipsis
  local prefix_len = math.floor((max_length - 3) / 2)
  local suffix_len = max_length - 3 - prefix_len
  return path:sub(1, prefix_len) .. "..." .. path:sub(-suffix_len)
end

-- Auto-cleanup missing files
local function cleanup_missing_files(files)
  local cleaned_files = {}
  local removed_count = 0

  for _, file in ipairs(files) do
    local full_path = to_absolute_path(file)
    if vim.fn.filereadable(full_path) == 1 then
      table.insert(cleaned_files, file)
    else
      removed_count = removed_count + 1
    end
  end

  if removed_count > 0 then
    vim.notify("Auto-cleaned " .. removed_count .. " missing files from marks")
  end

  return cleaned_files
end

-- Add current file to marks list
function M.add_file()
  local current_file = vim.fn.expand("%:p")
  if current_file == "" then
    vim.notify("No file to add to marks", vim.log.levels.WARN)
    return
  end

  local files = load_marks_list()
  files = cleanup_missing_files(files) -- Auto-cleanup
  local relative_path = to_relative_path(current_file)

  -- Check if file already exists
  for i, file in ipairs(files) do
    if file == relative_path then
      vim.notify("File already in marks at position " .. i, vim.log.levels.INFO)
      return
    end
  end

  -- Add file to the list
  table.insert(files, relative_path)
  save_marks_list(files)
  vim.notify("Added to marks: " .. vim.fn.fnamemodify(current_file, ":t"))
end

-- Select file from marks list by index
function M.select(index)
  local files = load_marks_list()
  if index <= #files and files[index] then
    local file_path = to_absolute_path(files[index])
    if vim.fn.filereadable(file_path) == 1 then
      vim.cmd("edit " .. vim.fn.fnameescape(file_path))
    else
      vim.notify("File not found: " .. file_path, vim.log.levels.ERROR)
    end
  else
    vim.notify("No file at marks position " .. index, vim.log.levels.WARN)
  end
end

-- Remove file from marks list by index
function M.remove(index)
  local files = load_marks_list()
  if index <= #files and files[index] then
    local removed_file = files[index]
    table.remove(files, index)
    save_marks_list(files)
    vim.notify("Removed from marks: " .. vim.fn.fnamemodify(removed_file, ":t"))
  else
    vim.notify("No file at marks position " .. index, vim.log.levels.WARN)
  end
end

-- Clear all files from marks list
function M.clear()
  save_marks_list({})
  vim.notify("Cleared marks list")
end

-- Manual cleanup function
function M.cleanup()
  local files = load_marks_list()
  local cleaned_files = cleanup_missing_files(files)

  if #cleaned_files ~= #files then
    save_marks_list(cleaned_files)
  else
    vim.notify("No missing files to cleanup")
  end
end

-- Parse buffer lines back to file list
local function parse_buffer_to_files(lines, original_files)
  local new_files = {}
  local file_map = {}

  -- Create a map of display names to full paths
  for _, file in ipairs(original_files) do
    local display_name = vim.fn.fnamemodify(file, ":t")
    file_map[display_name] = file
  end

  for _, line in ipairs(lines) do
    -- Skip empty lines
    if line ~= "" and line:match("%S") then
      -- Extract filename from the line (new format: "dir/filename.ext (status)" or "dir/filename.ext")
      local filename = line:match("/([^/%)]+)")
      if filename then
        -- Remove status text if present
        filename = filename:gsub("%s*%(.*%)$", "")
        if file_map[filename] then
          table.insert(new_files, file_map[filename])
        end
      end
    end
  end

  return new_files
end

-- Toggle marks menu as fully editable vim buffer
function M.toggle_menu()
  local files = load_marks_list()
  files = cleanup_missing_files(files) -- Auto-cleanup when opening menu

  if #files == 0 then
    vim.notify("No files in marks. Press <leader>h to add files.", vim.log.levels.INFO)
    return
  end

  -- Optimize path display for better readability
  local optimized_paths = optimize_paths_display(files)

  -- Create editable buffer content with minimal format
  local file_lines = {}
  for i, file in ipairs(files) do
    local full_path = to_absolute_path(file)
    local display_name = vim.fn.fnamemodify(file, ":t")
    local dir_name = optimized_paths[file] or vim.fn.fnamemodify(file, ":h")

    -- Truncate very long paths
    dir_name = truncate_path(dir_name, 40)

    local exists = vim.fn.filereadable(full_path) == 1

    -- Check if file is modified in a buffer
    local modified = false
    if exists then
      local bufnr = vim.fn.bufnr(full_path)
      if bufnr ~= -1 then
        modified = vim.fn.getbufvar(bufnr, "&modified") == 1
      end
    end

    -- Status text: only show for modified/missing files
    local status_text = ""
    if not exists then
      status_text = " (missing)"
    elseif modified then
      status_text = " (modified)"
    end

    -- New format: "dir/filename.ext (modified/missing)" or just "dir/filename.ext"
    local line = string.format("%s/%s%s", dir_name, display_name, status_text)
    table.insert(file_lines, line)
  end

  -- Create floating window with fully editable content
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, file_lines)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "buftype", "acwrite") -- Enable writing
  vim.api.nvim_buf_set_option(buf, "swapfile", false)
  vim.api.nvim_buf_set_option(buf, "modifiable", true) -- Fully editable
  vim.api.nvim_buf_set_name(buf, "marks://edit")
  vim.api.nvim_buf_set_option(buf, "filetype", "marks") -- For potential syntax highlighting

  -- Calculate window size - wider width and fixed height
  local width = math.floor(vim.o.columns * 0.3) -- Make it wider (60% of screen width)
  local height = 10 -- Fixed height of 10 lines
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create window with minimal appearance
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    border = "single",
    style = "minimal",
  })

  -- Set only essential keymaps (let vim handle dd, yy, p, etc.)
  local opts = { buffer = buf, silent = true }

  -- Auto-save and close
  vim.keymap.set("n", "q", function()
    -- Auto-save if buffer is modified
    if vim.api.nvim_buf_get_option(buf, "modified") then
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local new_files = parse_buffer_to_files(lines, files)

      if #new_files > 0 then
        save_marks_list(new_files)
        vim.notify("Marks auto-saved! (" .. #new_files .. " files)", vim.log.levels.INFO)
        -- Mark buffer as unmodified after saving
        vim.api.nvim_buf_set_option(buf, "modified", false)
      end
    end
    vim.cmd("close")
  end, opts)

  -- Escape also auto-saves
  vim.keymap.set("n", "<Esc>", function()
    -- Auto-save if buffer is modified
    if vim.api.nvim_buf_get_option(buf, "modified") then
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local new_files = parse_buffer_to_files(lines, files)

      if #new_files > 0 then
        save_marks_list(new_files)
        vim.notify("Marks auto-saved! (" .. #new_files .. " files)", vim.log.levels.INFO)
        -- Mark buffer as unmodified after saving
        vim.api.nvim_buf_set_option(buf, "modified", false)
      end
    end
    vim.cmd("close")
  end, opts)

  -- Open file on current line
  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    local filename = line:match("/([^/%)]+)")
    if filename then
      -- Remove status text if present
      filename = filename:gsub("%s*%(.*%)$", "")
      for i, file in ipairs(files) do
        if vim.fn.fnamemodify(file, ":t") == filename then
          vim.cmd("close")
          M.select(i)
          return
        end
      end
    end
  end, opts)

  -- Handle auto-save on buffer write (:w)
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local new_files = parse_buffer_to_files(lines, files)

      if #new_files > 0 then
        save_marks_list(new_files)
        vim.notify("Marks saved! (" .. #new_files .. " files)", vim.log.levels.INFO)
        -- Mark buffer as unmodified
        vim.api.nvim_buf_set_option(buf, "modified", false)
      else
        vim.notify("No valid files found", vim.log.levels.WARN)
      end
    end,
  })

  -- Show help message
  vim.notify("Format: dir/file.ext (modified/missing) | dd/yy/p to edit, q to quit", vim.log.levels.INFO)
end

-- Setup function with user's exact keymaps
function M.setup()
  -- Selection keymaps (mq, mw, me, mr, ma, ms, md, mf)
  vim.keymap.set("n", "mq", function()
    M.select(1)
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "mw", function()
    M.select(2)
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "me", function()
    M.select(3)
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "mr", function()
    M.select(4)
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "ma", function()
    M.select(5)
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "ms", function()
    M.select(6)
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "md", function()
    M.select(7)
  end, { noremap = true, silent = true })
  vim.keymap.set("n", "mf", function()
    M.select(8)
  end, { noremap = true, silent = true })

  -- Add file keymap
  vim.keymap.set("n", "<leader>h", M.add_file, { noremap = true, silent = true })

  -- Toggle menu keymap
  vim.keymap.set("n", "<leader>H", M.toggle_menu, { noremap = true, silent = true })
end

return M
