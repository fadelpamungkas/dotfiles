-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- show cursor line only in active window
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

-- todo comment
vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
  callback = function()
    vim.cmd([[
        hi link TodoComment WarningMsg
        match TodoComment /\(TODO\|FIXME\|FIX\|ISSUE\|NOTE\|INFO\|WARN\|PERF\|TEST\):/
        ]])
  end,
})

-- Close with q
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

-- auto toggle highlight search
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

-- Create a new scratch buffer
vim.api.nvim_create_user_command("Ns", function()
  vim.cmd([[
		execute 'vsplit | enew'
		setlocal buftype=nofile
		setlocal bufhidden=hide
		setlocal noswapfile
	]])
end, { nargs = 0 })

-- Compare clipboard to current buffer
vim.api.nvim_create_user_command("CompareClipboard", function()
  local ftype = vim.api.nvim_eval("&filetype") -- original filetype
  vim.cmd([[
		tabnew %
		Ns
		normal! P
		windo diffthis
	]])
  vim.cmd("set filetype=" .. ftype)
  vim.cmd("nnoremap <silent> <buffer> q <cmd>tabclose<CR>")
end, { nargs = 0 })

-- Assign it to a keymap
vim.keymap.set("n", "<leader>vc", "<cmd>CompareClipboard<cr>")

-- Compare clipboard to visual selection
vim.api.nvim_create_user_command("CompareClipboardSelection", function()
  vim.cmd([[
		" yank visual selection to z register
		normal! gv"zy
		" open new tab, set options to prevent save prompt when closing
		execute 'tabnew | setlocal buftype=nofile bufhidden=hide noswapfile'
		" paste z register into new buffer
		normal! V"zp
		Ns
		normal! Vp
		windo diffthis
	]])
  vim.cmd("nnoremap <silent> <buffer> q <cmd>tabclose<CR>")
end, {
  nargs = 0,
  range = true,
})

-- Assign it to a keymap
vim.keymap.set("v", "<leader>vc", "<esc><cmd>CompareClipboardSelection<cr>")

function _G.toggle_quickfix()
  local windows = vim.api.nvim_list_wins()

  for _, win in pairs(windows) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "quickfix" then
        vim.cmd("cclose")
        return
      end
    end
  end

  vim.cmd("botright copen")
end

vim.keymap.set("n", "<leader>q", ":lua toggle_quickfix()<CR>", { noremap = true, silent = true })

-- Check if file changed outside of vim
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- Session persistence
require("sessionizer").setup()

-- Custom marks
require("marks").setup()
