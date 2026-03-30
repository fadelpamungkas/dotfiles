-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
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

-- TODO comment highlighting
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

-- Close with q for special buffer types
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "qf",
    "help",
    "man",
    "vim",
    "lspinfo",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Quickfix toggle
local quickfix_height = 10
vim.keymap.set("n", "<leader>q", function()
  for _, win in pairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "quickfix" then
        quickfix_height = vim.api.nvim_win_get_height(win)
        vim.cmd("cclose")
        return
      end
    end
  end
  vim.cmd("botright copen " .. quickfix_height)
end, { noremap = true, silent = true })

-- Debounced file change detection
local check_timer = vim.uv.new_timer()
local function debounced_checktime()
  check_timer:stop()
  check_timer:start(100, 0, vim.schedule_wrap(function()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      pcall(vim.cmd.checktime)
    end
  end))
end

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  callback = debounced_checktime,
  pattern = { "*" },
})

-- Session persistence
require("sessionizer").setup()

-- Custom marks
require("marks").setup()
