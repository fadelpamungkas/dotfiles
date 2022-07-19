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
opt.scrolloff = 4 -- Columns of context
opt.signcolumn = "no" -- always show signcolumns
g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_sizestyle = "H"

g.do_filetype_lua = 1
g.did_load_filetypes = 0

-- Remap space as leader key
map('n', '<Space>', '<Nop>', { silent = true })
g.mapleader = ' '
g.maplocalleader = ' '

map('i', 'jk', '<Esc>', { noremap = true })
map('v', '>', '>gv', { noremap = true })
map('v', '<', '<gv', { noremap = true })
map('n', '<c-s>', ':%s/', { noremap = true })
map('n', '<c-n>', ':set number!<CR>', { noremap = true })
map('v', '<c-c>', '"+y', { noremap = true })
map('n', '<Right>', '<cmd>:vertical resize +2<CR>', { noremap = true })
map('n', '<Left>', '<cmd>:vertical resize -2<CR>', { noremap = true })
map('n', '<Up>', '<cmd>resize +2<CR>', { noremap = true })
map('n', '<Down>', '<cmd>resize -2<CR>', { noremap = true })
map('n', '<c-j>', '<c-w>j', { noremap = true })
map('n', '<c-k>', '<c-w>k', { noremap = true })
map('n', '<c-h>', '<c-w>h', { noremap = true })
map('n', '<c-l>', '<c-w>l', { noremap = true })
map('n', 'gV', '`[V`]', { noremap = true }) -- Selecting pasted text
map('n', '<leader>e', ':Rexplore<CR>', { noremap = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    require("vim.highlight").on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Split window on VimEnter
-- local startup_group = vim.api.nvim_create_augroup('User AlphaReady', { clear = true })
-- vim.api.nvim_create_autocmd({ 'VimEnter' }, {
--   command = "vsplit<CR>",
--   group = startup_group,
--   pattern = '*',
-- })


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
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	print "Cloning packer .."

	fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }

	print "Packer cloned successfully!"

	-- install plugins + compile their configs
	vim.cmd "packadd packer.nvim"
	require "plugins"
	vim.cmd "PackerSync"
end

local function cmd(lhs, fun, opt)
	vim.api.nvim_create_user_command(lhs, fun, opt or {})
end

local packer_cmd = function(callback)
	return function()
		vim.cmd "silent! luafile %"
		require "plugins"
		require("packer")[callback]()
	end
end

cmd("PackerClean", packer_cmd "clean")
cmd("PackerCompile", packer_cmd "compile")
cmd("PackerInstall", packer_cmd "install")
cmd("PackerStatus", packer_cmd "status")
cmd("PackerSync", packer_cmd "sync")
cmd("PackerUpdate", packer_cmd "update")

cmd("PackerSnapshot", function(info)
	require("packer").snapshot(info.args)
end, { nargs = "+" })

cmd("PackerSnapshotDelete", function(info)
	require("packer.snapshot").delete(info.args)
end, { nargs = "+" })

cmd("PackerSnapshotRollback", function(info)
	require("packer").rollback(info.args)
end, { nargs = "+" })

require('plugins')
require('configs.colorscheme')
