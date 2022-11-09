-- Load Impatient if available
local present, impatient = pcall(require, "impatient")
if present then
	impatient.enable_profile()
end

-- Bacic Vim Configurations
local opt = vim.opt
local g = vim.g
local map = vim.api.nvim_set_keymap

opt.updatetime = 250
opt.background = "dark"
opt.clipboard = "unnamedplus"
opt.showmatch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true
opt.autoindent = true
opt.smartindent = true
opt.showmode = false
opt.mouse = "a"
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.undofile = true
opt.cursorline = true
opt.termguicolors = true
opt.splitbelow = true -- Open new split below
opt.splitright = true -- Open new split to the right
opt.completeopt = { "menu", "menuone", "noselect" }
opt.scrolloff = 2 -- Columns of context
opt.signcolumn = "auto" -- always show signcolumns
opt.cmdheight = 1 -- v0.8.0
g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_sizestyle = "H"

-- Remap space as leader key
map("n", "<Space>", "<Nop>", { silent = true })
g.mapleader = " "
g.maplocalleader = " "

map("i", "jk", "<Esc>", { noremap = true })
map("v", ">", ">gv", { noremap = true })
map("v", "<", "<gv", { noremap = true })
map("n", "<c-s>", ":%s/", { noremap = true })
map("n", "<Right>", "<cmd>:vertical resize +2<CR>", { noremap = true })
map("n", "<Left>", "<cmd>:vertical resize -2<CR>", { noremap = true })
map("n", "<Up>", "<cmd>resize +2<CR>", { noremap = true })
map("n", "<Down>", "<cmd>resize -2<CR>", { noremap = true })
map("n", "<c-j>", "<c-w>j", { noremap = true })
map("n", "<c-k>", "<c-w>k", { noremap = true })
map("n", "<c-h>", "<c-w>h", { noremap = true })
map("n", "<c-l>", "<c-w>l", { noremap = true })
map("n", "gV", "`[V`]", { noremap = true }) -- Selecting pasted text

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		require("vim.highlight").on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- disable some builtin vim plugins
local default_plugins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}

for _, plugin in pairs(default_plugins) do
	g["loaded_" .. plugin] = 1
end

_G.lazy = function(plugin, timer)
	if plugin then
		timer = timer or 0
		vim.defer_fn(function()
			require("packer").loader(plugin)
		end, timer)
	end
end

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	print("Cloning packer ..")

	fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })

	print("Packer cloned successfully!")

	-- install plugins + compile their configs
	vim.cmd("packadd packer.nvim")
	require("plugins")
	vim.cmd("PackerSync")
end

local function cmd(lhs, fun, opt)
	vim.api.nvim_create_user_command(lhs, fun, opt or {})
end

local packer_cmd = function(callback)
	return function()
		vim.cmd("silent! luafile %")
		require("plugins")
		require("packer")[callback]()
	end
end

cmd("PackerClean", packer_cmd("clean"))
cmd("PackerCompile", packer_cmd("compile"))
cmd("PackerInstall", packer_cmd("install"))
cmd("PackerStatus", packer_cmd("status"))
cmd("PackerSync", packer_cmd("sync"))
cmd("PackerUpdate", packer_cmd("update"))

cmd("PackerSnapshot", function(info)
	require("packer").snapshot(info.args)
end, { nargs = "+" })

cmd("PackerSnapshotDelete", function(info)
	require("packer.snapshot").delete(info.args)
end, { nargs = "+" })

cmd("PackerSnapshotRollback", function(info)
	require("packer").rollback(info.args)
end, { nargs = "+" })

require("plugins")

local cfg = {
	debug = false, -- set to true to enable debug logging
	log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
	-- default is  ~/.cache/nvim/lsp_signature.log
	verbose = false, -- show debug line number

	bind = true, -- This is mandatory, otherwise border config won't get registered.
	-- If you want to hook lspsaga or other signature handler, pls set to false
	doc_lines = 2, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
	-- set to 0 if you DO NOT want any API comments be shown
	-- This setting only take effect in insert mode, it does not affect signature help in normal
	-- mode, 10 by default

	max_height = 12, -- max height of signature floating_window
	max_width = 80, -- max_width of signature floating_window
	noice = false, -- set to true if you using noice to render markdow
	wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long

	floating_window = false, -- show hint in a floating window, set to false for virtual text only mode

	floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
	-- will set to true when fully tested, set to false will use whichever side has more space
	-- this setting will be helpful if you do not want the PUM and floating win overlap

	floating_window_off_x = 1, -- adjust float windows x position.
	floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines

	close_timeout = 4000, -- close floating window after ms when laster parameter is entered
	fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
	hint_enable = true, -- virtual hint enable
	hint_prefix = "🐼 ", -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
	hint_scheme = "String",
	hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
	handler_opts = {
		border = "rounded", -- double, rounded, single, shadow, none
	},

	always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

	auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
	extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
	zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

	padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc

	transparency = nil, -- disabled by default, allow floating win transparent value 1~100
	shadow_blend = 36, -- if you using shadow as border use this set the opacity
	shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
	timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
	toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'

	select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
	move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
}

-- recommended:
require("lsp_signature").setup(cfg) -- no need to specify bufnr if you don't use toggle_key
