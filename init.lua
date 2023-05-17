-- Bacic Vim Configurations
local opt = vim.opt
local g = vim.g
local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	vim.keymap.set(mode, lhs, rhs, opts)
end

if g.neovide ~= nil then
	-- vim.o.guifont = "Fira Code:h13"
	-- vim.o.guifont = "Monaco:h13"
	vim.o.guifont = "Menlo:h13"
	g.neovide_cursor_antialiasing = true
	g.neovide_cursor_vfx_mode = ""
	g.neovide_cursor_animation_length = 0.05
	g.neovide_cursor_trail_size = 0
	g.neovide_scale_factor = 1
	g.neovide_transparency = 1
	g.transparency = 0.5
	-- g.neovide_background_color = "#0f1117"
	vim.keymap.set("n", "<F9>", ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>")
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
opt.showmode = true
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
opt.signcolumn = "yes" -- always show signcolumns
opt.cmdheight = 1 -- v0.8.0
opt.laststatus = 3

-- Remap space as leader key
map("n", "<Space>", "<Nop>", { silent = true })
g.mapleader = " "
g.maplocalleader = " "

map("i", "jk", "<Esc>")
map("i", "<Esc>", "<Esc>")

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("n", "<c-s>", [[:%s/\<<c-r><c-w>\>/<c-r><c-w>/gI<left><left><left>]])
map("n", "<Right>", "<cmd>:vertical resize +1<CR>")
map("n", "<Left>", "<cmd>:vertical resize -1<CR>")
map("n", "<Up>", "<cmd>resize +1<CR>")
map("n", "<Down>", "<cmd>resize -1<CR>")
map("n", "<c-j>", "<c-w>j")
map("n", "<c-k>", "<c-w>k")
map("n", "<c-h>", "<c-w>h")
map("n", "<c-l>", "<c-w>l")
map("n", "gV", "`[V`]")
map({ "n", "x" }, "gw", "*N")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true })
map("x", "n", "'Nn'[v:searchforward]", { expr = true })
map("o", "n", "'Nn'[v:searchforward]", { expr = true })
map("n", "N", "'nN'[v:searchforward]", { expr = true })
map("x", "N", "'nN'[v:searchforward]", { expr = true })
map("o", "N", "'nN'[v:searchforward]", { expr = true })

map("v", ">", ">gv")
map("v", "<", "<gv")
-- map("v", "J", ":m '>+1<CR>gv=gv")
-- map("v", "K", ":m '<-2<CR>gv=gv")

map("x", "<leader>p", [["_dP]])
map("x", "<leader>P", [["_dp]])

require("lazyconfig")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("commands")
	end,
})

-- vim.g.falcon_inactive = 0
-- vim.g.falcon_background = 1
-- vim.g.falcon_settings = {
-- 	variation = "modern",
-- }
-- package.loaded["falcon"] = nil
-- require("lush")(require("falcon").setup())

vim.cmd.colorscheme("kanagawa")
