local M = {}

-- Session configuration
local session_dir = vim.fn.stdpath("state") .. "/sessions/"

-- Cache for git branch detection
local cached_branch = nil
local cached_cwd = nil

-- Optimize session options
vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize",
  "winpos",
}

-- Lazy git branch detection - only check when needed and if in git repo
local function get_git_branch()
  local current_cwd = vim.fn.getcwd()
  if cached_cwd ~= current_cwd then
    cached_cwd = current_cwd
    -- Check if we're in a git repo first (faster)
    if vim.fn.isdirectory(current_cwd .. "/.git") == 1 then
      cached_branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
      cached_branch = cached_branch ~= "" and cached_branch or nil
    else
      cached_branch = nil
    end
  end
  return cached_branch
end

-- Validate session file
local function is_valid_session(session_file)
  if vim.fn.filereadable(session_file) ~= 1 then
    return false
  end
  local content = vim.fn.readfile(session_file, "", 10)
  if #content == 0 then
    return false
  end
  return content[1]:match('^let SessionLoad') ~= nil
end

-- Generate session file path
local function get_session_file()
  local cwd = vim.fn.getcwd()
  -- Use full path for unique session identification
  local full_path = cwd:gsub("^/", ""):gsub("/", "_"):gsub("[^%w_.-]", "")
  local session_name = full_path

  local branch = get_git_branch()
  if branch then
    session_name = session_name .. "_" .. branch:gsub("[^%w_-]", "")
  end

  return session_dir .. session_name .. ".vim"
end

-- Check if there are real files open
local function has_real_files()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" and vim.fn.filereadable(name) == 1 then
        return true
      end
    end
  end
  return false
end

-- Save current session
function M.save_session()
  if not has_real_files() then
    return
  end

  local ok, err = pcall(function()
    vim.fn.mkdir(session_dir, "p")
    local session_file = get_session_file()
    vim.cmd("mksession! " .. vim.fn.fnameescape(session_file))
  end)

  if not ok then
    vim.notify("Failed to save session: " .. err, vim.log.levels.ERROR)
  end
end

-- Load session for current directory/branch
function M.load_session()
  local session_file = get_session_file()
  if vim.fn.filereadable(session_file) == 1 then
    if not is_valid_session(session_file) then
      vim.notify("Session file is corrupted", vim.log.levels.ERROR)
      return
    end

    local ok, err = pcall(function()
      local current_win = vim.api.nvim_get_current_win()
      vim.cmd("source " .. vim.fn.fnameescape(session_file))
      -- Try to restore original window if it still exists
      if vim.api.nvim_win_is_valid(current_win) then
        vim.api.nvim_set_current_win(current_win)
      end
    end)

    if not ok then
      vim.notify("Failed to load session: " .. err, vim.log.levels.ERROR)
    end
  else
    print("No session found for current directory" .. (get_git_branch() and " and branch" or ""))
  end
end

-- Setup function to initialize autocmds and keymaps
function M.setup()
  -- Auto-save session on exit
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = M.save_session,
  })

  -- Branch change detection - auto-save when switching branches externally
  vim.api.nvim_create_autocmd("FocusGained", {
    callback = function()
      local old_branch = cached_branch
      cached_cwd = nil -- Force refresh
      local new_branch = get_git_branch()
      
      if old_branch and new_branch and old_branch ~= new_branch then
        M.save_session() -- Save previous branch session
      end
    end,
  })

  -- Load session keymap
  vim.keymap.set("n", "<leader>z", M.load_session, { noremap = true, silent = true })
end

return M