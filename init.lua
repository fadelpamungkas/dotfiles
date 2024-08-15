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
				table.insert(results, string.format("%s%d ", attr[2], #n))
			end
		end
		diagnostics = table.concat(results)
	end,
})

local function unsaved_buffers()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_option(buf, "modified") then
			return "Unsaved"
		end
	end
	return ""
end

local function file_section()
	local name = (vim.fn.expand("%:.") == "") and "No Name" or vim.fn.expand("%:.")
	return string.format("%s ", name)
end

-- LSP Progress
local lsp_progress = {
	client = nil,
	kind = nil,
	title = nil,
	percentage = nil,
	message = nil,
}

vim.api.nvim_create_autocmd("LspProgress", {
	desc = "Update LSP progress in statusline",
	pattern = { "begin", "report", "end" },
	callback = function(args)
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
				vim.cmd.redrawstatus()
			end, 500)
		else
			vim.cmd.redrawstatus()
		end
	end,
})

local function lsp_status()
	if not rawget(vim, "lsp") then
		return ""
	end

	if vim.o.columns < 120 then
		return ""
	end

	if not lsp_progress.client or not lsp_progress.title then
		return ""
	end

	local title = lsp_progress.title or ""
	local percentage = (lsp_progress.percentage and (lsp_progress.percentage .. "%%")) or ""
	local message = lsp_progress.message or ""

	local lsp_message = string.format("%s", title)

	if message ~= "" then
		lsp_message = string.format("%s %s", lsp_message, message)
	end

	if percentage ~= "" then
		lsp_message = string.format("%s %s", lsp_message, percentage)
	end

	return string.format("%s ", lsp_message)
end

local function get_branch()
	local branch = vim.b.gitsigns_head

	if branch == "" or branch == nil then
		return ""
	end

	return string.format("%s ", branch)
end

_G.set_statusline = function()
	return file_section()
		.. "%m%r"
		.. unsaved_buffers()
		.. diagnostics
		.. lsp_status()
		.. "%="
		.. get_branch()
		.. "%l:%c %L %p%%"
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = statusline_group,
	command = "setlocal statusline=%!v:lua.set_statusline()",
})

-- vim.cmd.colorscheme("lunaperche")
-- vim.api.nvim_set_hl(0, "Normal", { bg = NONE })
-- vim.api.nvim_set_hl(0, "ModeMsg", { bg = NONE })
-- vim.api.nvim_set_hl(0, "StatusLine", { bg = NONE })

-- vim.cmd.colorscheme("default")
-- vim.api.nvim_set_hl(0, "statusline", { bg = NONE })
-- vim.o.background = "dark"
-- vim.cmd([[ colorscheme neofusion ]])
