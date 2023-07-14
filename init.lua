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
opt.signcolumn = "yes"
opt.number = true
opt.relativenumber = true

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

vim.cmd.colorscheme("kanagawa-dragon")
