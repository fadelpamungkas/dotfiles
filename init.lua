local opt = vim.opt
local g = vim.g
local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	vim.keymap.set(mode, lhs, rhs, opts)
end

if g.neovide ~= nil then
	vim.o.guifont = "Menlo:h14"
	g.neovide_cursor_antialiasing = true
	g.neovide_cursor_vfx_mode = ""
	g.neovide_cursor_animation_length = 0.05
	g.neovide_cursor_trail_size = 0
	g.neovide_scale_factor = 1
	g.neovide_transparency = 1
	g.transparency = 0.5
	vim.keymap.set("n", "<F11>", ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>")
end

opt.updatetime = 200
opt.background = "dark"
opt.clipboard = "unnamedplus"
opt.showmatch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true
opt.inccommand = "split"
opt.autoindent = true
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.undofile = true
opt.wrap = false
opt.cursorline = true
opt.termguicolors = true
opt.splitbelow = true
opt.splitright = true
opt.completeopt = { "menu", "menuone", "noselect" }
opt.scrolloff = 2
opt.laststatus = 3
opt.sessionoptions = "buffers,folds,help,tabpages,winsize,resize,winpos"
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = false
-- opt.signcolumn = "yes"
-- opt.number = true
-- opt.relativenumber = true

-- Remap space as leader key
g.mapleader = " "
g.maplocalleader = " "
map("n", "<Space>", "<Nop>", { silent = true })

map("i", "jk", "<Esc>")
map("i", "<Esc>", "<Esc>")

map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("n", "<Right>", "<cmd>:vertical resize +1<CR>")
map("n", "<Left>", "<cmd>:vertical resize -1<CR>")
map("n", "<Up>", "<cmd>resize +1<CR>")
map("n", "<Down>", "<cmd>resize -1<CR>")

map({ "n", "t" }, "<c-j>", "<c-w>j")
map({ "n", "t" }, "<c-k>", "<c-w>k")
map({ "n", "t" }, "<c-h>", "<c-w>h")
map({ "n", "t" }, "<c-l>", "<c-w>l")

map("n", "<c-s>", [[:%s/\<<c-r><c-w>\>/<c-r><c-w>/gI<left><left><left>]])
map("n", "gV", "`[V`]")

map("x", "<leader>p", [["_dP]])
map("x", "<leader>P", [["_dp]])

map("n", "<leader>w", "<cmd>set wrap!<CR>")

-- map('n', '<tab>', ':cnext<CR>', { noremap = true, silent = true })
-- map('n', '<s-tab>', ':cprev<CR>', { noremap = true, silent = true })

-- Automatically Pair brackets, parethesis, and quotes
map("i", "(<CR>", "(<CR>)<Esc>O")
map("i", "{<CR>", "{<CR>}<Esc>O")
map("i", "`<CR>", "`<CR>`<Esc>O")
------------------------------

-- convert buffer (json) to one line/minified json and vice versa
map("n", "<Leader>mb", "<cmd>%!jq -c .<CR>")
map("v", "<Leader>mb", ":'<,'>!jq -c .<CR>")
map("n", "<Leader>mc", ":w !jq -c . | pbcopy<CR><CR>")
map("v", "<Leader>mc", ":w !jq -c . | pbcopy<CR><CR>")
map("n", "<Leader>M", "<cmd>%!jq .<CR>")
map("v", "<Leader>M", ":'<,'>!jq .<CR>")

require("lazyconfig")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("commands")
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "FlashMatch", { fg = "lightgrey" })
		vim.api.nvim_set_hl(0, "FlashLabel", { fg = "orange" })
		vim.api.nvim_set_hl(0, "FlashCurrent", { fg = "cyan" })
	end,
})

-- additional filetypes
vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

-- Statusline
local statusline_group = vim.api.nvim_create_augroup("StatusLine", { clear = true })

local diagnostics = ""
vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufWinEnter" }, {
	group = statusline_group,
	callback = function()
		local results = {}
		for _, attr in pairs({
			{ "Error", "E" },
			{ "Warn", "W" },
			{ "Hint", "H" },
			{ "Info", "I" },
		}) do
			local n = vim.diagnostic.get(0, { severity = attr[1] })
			if #n > 0 then
				table.insert(results, string.format(" %s%d", attr[2], #n))
			end
		end
		diagnostics = table.concat(results)
	end,
})

local function unsaved_buffers()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_option(buf, "modified") then
			return " Unsaved "
		end
	end
	return ""
end

local function file_section()
	local name = (vim.fn.expand("%:.") == "") and "No Name" or vim.fn.expand("%:.")
	return string.format("%s ", name)
end

-- LSP Progress
local lsp_progress = ""
vim.api.nvim_create_autocmd("User", {
	pattern = "LspProgressUpdate",
	group = vim.api.nvim_create_augroup("lsp_progress_statusline", {}),
	callback = function(opts)
		if not vim.lsp.get_client_by_id(opts.data.client_id) then
			return
		end
		local data = opts.data.result.value
		if data.kind ~= "end" then
			lsp_progress = data.percentage == nil and "" or string.format(" (%d%%%%)", data.percentage)
			lsp_progress = lsp_progress .. " " .. data.title
			lsp_progress = lsp_progress .. " " .. (data.message == nil and "" or data.message)
		else
			lsp_progress = ""
		end
		vim.cmd.redrawstatus()
	end,
})

local branch_cache = nil
local function get_branch()
	if branch_cache == nil then
		local branch = vim.fn.systemlist("git branch --show-current 2>/dev/null")
		if vim.v.shell_error == 0 and #branch > 0 then
			branch_cache = string.format("  %s ", branch[1])
		else
			branch_cache = ""
		end
	end
	return branch_cache
end

_G.set_statusline = function()
	return file_section() .. "%m%r" .. unsaved_buffers() .. diagnostics .. lsp_progress .. "%=" .. get_branch() .. "%l:%c %L %p%%"
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = statusline_group,
	command = "setlocal statusline=%!v:lua.set_statusline()",
})

vim.api.nvim_create_autocmd("BufWritePost", {
	group = statusline_group,
	callback = function()
		branch_cache = nil
	end,
})

-- vim.cmd.colorscheme("lunaperche")
-- vim.api.nvim_set_hl(0, "Normal", { bg = NONE })
-- vim.api.nvim_set_hl(0, "ModeMsg", { bg = NONE })
-- vim.api.nvim_set_hl(0, "StatusLine", { bg = NONE })

-- vim.cmd.colorscheme("default")
-- vim.api.nvim_set_hl(0, "statusline", { bg = NONE })
-- vim.o.background = "dark"
-- vim.cmd([[ colorscheme neofusion ]])

local response_buf = nil

vim.api.nvim_create_user_command("ExecuteCurl", function(opts)
	local start_line, end_line

	if opts.range == 0 then
		start_line = 0
		end_line = -1
	else
		start_line = opts.line1 - 1
		end_line = opts.line2
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
	local curl_command = table.concat(lines, " "):gsub("%s+", " ")

	local result = ""
	local job_id = vim.fn.jobstart(curl_command, {
		on_stdout = function(_, data)
			result = result .. table.concat(data, "\n")
		end,
		on_exit = function()
			vim.schedule(function()
				result = result:gsub("\r\n", "\n")

				if response_buf and vim.api.nvim_buf_is_valid(response_buf) then
					vim.api.nvim_buf_set_lines(response_buf, 0, -1, false, {})
				else
					response_buf = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_buf_set_option(response_buf, "buftype", "nofile")
					vim.api.nvim_buf_set_option(response_buf, "bufhidden", "hide")
					vim.api.nvim_buf_set_option(response_buf, "swapfile", false)
					vim.api.nvim_buf_set_name(response_buf, "Curl Response")
				end

				vim.api.nvim_buf_set_lines(response_buf, 0, -1, false, vim.split(result, "\n"))

				local win_id = vim.fn.bufwinid(response_buf)
				if win_id == -1 then
					vim.cmd("vsplit")
					vim.api.nvim_win_set_buf(0, response_buf)
				else
					vim.api.nvim_set_current_win(win_id)
				end

				if result:match("^%s*{") or result:match("^%s*%[") then
					vim.api.nvim_buf_set_option(response_buf, "filetype", "json")
				else
					vim.api.nvim_buf_set_option(response_buf, "filetype", "http")
				end

				vim.api.nvim_buf_set_keymap(response_buf, "n", "q", ":hide<CR>", { noremap = true, silent = true })
			end)
		end,
	})

	if job_id == 0 then
		print("Failed to start job")
	elseif job_id == -1 then
		print("Invalid arguments")
	else
		print("Executing curl command...")
	end
end, { range = true })

vim.keymap.set("v", "<leader>xc", ":ExecuteCurl<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>xc", "vap:ExecuteCurl<CR>", { noremap = true, silent = true })
