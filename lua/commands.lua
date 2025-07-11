-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Show cursor line only in active window
local cursorGrp = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  pattern = "*",
  command = "set cursorline",
  group = cursorGrp,
})
vim.api.nvim_create_autocmd(
  { "InsertEnter", "WinLeave" },
  { pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- TODO comment highlighting (with error protection)
vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
  callback = function()
    pcall(function()
      vim.cmd([[
        hi link TodoComment WarningMsg
        match TodoComment /\(TODO\|FIXME\|FIX\|ISSUE\|NOTE\|INFO\|WARN\|PERF\|TEST\):/
        ]])
    end)
  end,
})

-- Auto toggle highlight search
local ns = vim.api.nvim_create_namespace("toggle_hlsearch")

local function toggle_hlsearch(char)
  if vim.fn.mode() == "n" then
    local keys = { "<CR>", "n", "N", "*", "#", "?", "/" }
    local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))

    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end

vim.on_key(toggle_hlsearch, ns)

-- Close with q for special buffer types
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "qf",
    "help",
    "man",
    "vim",
    "lspinfo",
    "spectre_panel",
    "tsplayground",
    "PlenaryTestPopup",
    "rest_nvim_results",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Enhanced quickfix management
local quickfix_height = 10 -- Remember quickfix height

local function get_quickfix_window()
  for _, win in pairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "quickfix" then
        return win
      end
    end
  end
  return nil
end

function _G.toggle_quickfix()
  local qf_win = get_quickfix_window()

  if qf_win then
    -- Save height before closing
    quickfix_height = vim.api.nvim_win_get_height(qf_win)
    vim.cmd("cclose")
  else
    -- Open with remembered height
    vim.cmd("botright copen " .. quickfix_height)
  end
end

vim.keymap.set("n", "<leader>q", ":lua toggle_quickfix()<CR>", { noremap = true, silent = true })

-- Create a new scratch buffer
vim.api.nvim_create_user_command("Ns", function()
  pcall(function()
    vim.cmd("vsplit")
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)

    local opts = {
      buftype = "nofile",
      bufhidden = "hide",
      swapfile = false,
    }

    for opt, val in pairs(opts) do
      vim.api.nvim_buf_set_option(buf, opt, val)
    end
  end)
end, { nargs = 0 })

-- Compare clipboard to current buffer
vim.api.nvim_create_user_command("CompareClipboard", function()
  pcall(function()
    local ftype = vim.bo.filetype
    vim.cmd("tabnew %")
    vim.cmd("Ns")
    vim.cmd("normal! P")
    vim.cmd("windo diffthis")
    vim.bo.filetype = ftype
    vim.keymap.set("n", "q", "<cmd>tabclose<CR>", { buffer = true, silent = true })
  end)
end, { nargs = 0 })

-- Compare clipboard to visual selection
vim.api.nvim_create_user_command("CompareClipboardSelection", function()
  pcall(function()
    vim.cmd('normal! gv"zy')

    vim.cmd("tabnew")
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)

    local opts = { buftype = "nofile", bufhidden = "hide", swapfile = false }
    for opt, val in pairs(opts) do
      vim.api.nvim_buf_set_option(buf, opt, val)
    end

    vim.cmd('normal! V"zp')
    vim.cmd("Ns")
    vim.cmd("normal! Vp")
    vim.cmd("windo diffthis")
    vim.keymap.set("n", "q", "<cmd>tabclose<CR>", { buffer = true, silent = true })
  end)
end, {
  nargs = 0,
  range = true,
})

-- Keymaps for clipboard comparison
vim.keymap.set("n", "<leader>vc", "<cmd>CompareClipboard<cr>")
vim.keymap.set("v", "<leader>vc", "<esc><cmd>CompareClipboardSelection<cr>")

-- Debounced file change detection
local file_check_timer = nil
local function debounced_checktime()
  if file_check_timer then
    vim.fn.timer_stop(file_check_timer)
  end

  file_check_timer = vim.fn.timer_start(100, function()
    -- Don't run checktime in command-line window or command mode
    local mode = vim.fn.mode()
    local cmdwin = vim.fn.getcmdwintype()

    if mode ~= "c" and cmdwin == "" then
      pcall(vim.cmd.checktime)
    end
    file_check_timer = nil
  end)
end

-- Check if file changed outside of vim (with debouncing)
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  callback = debounced_checktime,
  pattern = { "*" },
})

-- Session persistence
require("sessionizer").setup()

-- Custom marks
require("marks").setup()
