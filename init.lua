-- Load Impatient if available
-- local present, impatient = pcall(require, "impatient")
-- if present then
-- 	impatient.enable_profile()
-- end

-- Bacic Vim Configurations
local opt = vim.opt
local g = vim.g
local map = vim.api.nvim_set_keymap

if g.neovide ~= nil then
	vim.o.guifont = "Inconsolata Nerd Font Mono:h14"
	g.neovide_cursor_antialiasing = true
	g.neovide_cursor_vfx_mode = ""
	g.neovide_cursor_animation_length = 0.05
	g.neovide_cursor_trail_size = 0
	g.neovide_scale_factor = 1
	g.neovide_transparency = 0.95
	g.transparency = 0.5 -- g.neovide_background_color = "#0f1117"
	vim.keymap.set("n", "<F9>", ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>")
end

opt.updatetime = 50
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
opt.mouse = ""
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.undofile = true
opt.wrap = false
opt.cursorline = true
opt.termguicolors = true
opt.splitbelow = true -- Open new split below
opt.splitright = true -- Open new split to the right
opt.completeopt = { "menu", "menuone", "noselect" }
opt.scrolloff = 2 -- Columns of context
opt.signcolumn = "auto" -- always show signcolumns
opt.cmdheight = 1 -- v0.8.0

-- Remap space as leader key
map("n", "<Space>", "<Nop>", { silent = true })
g.mapleader = " "
g.maplocalleader = " "

map("i", "jk", "<Esc>", { noremap = true })

map("n", "<c-s>", [[:%s/\<<c-r><c-w>\>/<c-r><c-w>/gI<left><left><left>]], { noremap = true })
map("n", "<Right>", "<cmd>:vertical resize +2<CR>", { noremap = true })
map("n", "<Left>", "<cmd>:vertical resize -2<CR>", { noremap = true })
map("n", "<Up>", "<cmd>resize +2<CR>", { noremap = true })
map("n", "<Down>", "<cmd>resize -2<CR>", { noremap = true })
map("n", "<c-j>", "<c-w>j", { noremap = true })
map("n", "<c-k>", "<c-w>k", { noremap = true })
map("n", "<c-h>", "<c-w>h", { noremap = true })
map("n", "<c-l>", "<c-w>l", { noremap = true })
map("n", "gV", "`[V`]", { noremap = true })
map("n", "n", "nzzzv", { noremap = true })
map("n", "N", "Nzzzv", { noremap = true })

map("v", ">", ">gv", { noremap = true })
map("v", "<", "<gv", { noremap = true })
map("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
map("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })

map("x", "<leader>p", [["_dP]], { noremap = true })
map("x", "<leader>P", [["_dp]], { noremap = true })

map("n", "<leader>o", "<cmd>SymbolsOutlineOpen<CR>", { noremap = true })

-- don't load the plugins below
local builtins = {
	"gzip",
	"zip",
	"zipPlugin",
	"fzf",
	"tar",
	"tarPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"matchit",
	"matchparen",
	"logiPat",
	"rrhelper",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
}

for _, plugin in ipairs(builtins) do
	vim.g["loaded_" .. plugin] = 1
end

require("lazyconfig")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("commands")
	end,
})
