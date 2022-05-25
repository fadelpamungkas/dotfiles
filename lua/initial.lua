--
-- Bacic Vim Configurations
vim.o.updatetime = 250
vim.opt.undofile = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.splitbelow = true -- Open new split below
vim.opt.splitright = true -- Open new split to the right
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

-- Remap space as leader key
vim.api.nvim_set_keymap( 'n' , '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('i', 'jk','<Esc>')
vim.api.nvim_set_keymap( 'v' , '>', '>gv', { noremap = true })
vim.api.nvim_set_keymap( 'v' , '<', '<gv', { noremap = true })

vim.api.nvim_set_keymap( 'n' , 'Right', '<cmd>:vertical resize +2<CR>', { noremap = true })
vim.api.nvim_set_keymap( 'n' , 'Left', '<cmd>:vertical resize -2<CR>', { noremap = true })
vim.api.nvim_set_keymap( 'n' , 'Up', '<cmd>resize +2<CR>', { noremap = true })
vim.api.nvim_set_keymap( 'n' , 'Down', '<cmd>resize -2<CR>', { noremap = true })
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-l>', '<c-w>l')
vim.keymap.set('n', '<leader>sv', '<cmd>vsplit<CR>')
vim.keymap.set('n', '<leader>sh', '<cmd>split<CR>')


-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    require("vim.highlight").on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


--
-- Initialize Packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd bufwritepost initial.lua source <afile> | PackerSync
  augroup end
]]

return require('packer').startup({ function()
  -- packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'sainnhe/everforest'
  use 'sainnhe/gruvbox-material'
  use "EdenEast/nightfox.nvim" -- Packer
  -- use "rebelot/kanagawa.nvim"
  -- use 'marko-cerovac/material.nvim'
  -- use 'Mofiqul/adwaita.nvim'
  -- use 'windwp/wind-colors'
  -- use 'kyazdani42/blue-moon'
  -- use 'fenetikm/falcon'
  -- use { 'lifepillar/vim-gruvbox8', opt = true }
  -- use 'ellisonleao/gruvbox.nvim' -- colorscheme
  -- use 'davidosomething/vim-colors-meh' -- colorscheme
  use 'neovim/nvim-lspconfig' -- lsp client
  use 'hrsh7th/nvim-cmp' -- autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- lsp source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- snippets source for nvim-cmp
  use 'l3mon4d3/luasnip' -- snippets plugin
  use 'tpope/vim-surround' -- surround
  use 'tpope/vim-commentary' -- faster code commenting
  use 'tpope/vim-fugitive' -- git integration
  use 'akinsho/toggleterm.nvim' -- terminal integration
  use 'nvim-lualine/lualine.nvim' -- statusline
  use 'lewis6991/impatient.nvim' -- Startup profiler
  use { 'nvim-treesitter/nvim-treesitter', run = ':tsupdate' } -- treesitter syntax highlighting
  use 'nvim-treesitter/nvim-treesitter-textobjects' -- Additional textobjects for treesitter
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } -- fzf native c for telescope
  use { 'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  } -- fuzzy finder
  use {
    'goolord/alpha-nvim',
    config = function()
      require("configs.alpha")
    end,
  }
  if packer_bootstrap then
    require('packer').sync()
  end
end,
config = {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
} }
)

