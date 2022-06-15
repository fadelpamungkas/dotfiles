-- -- Initialize Packer
-- local fn = vim.fn
-- local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
-- if fn.empty(fn.glob(install_path)) > 0 then
--   packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
-- end
--
-- -- only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]
-- vim.cmd [[
--   augroup packer_user_config
--     autocmd!
--     autocmd bufwritepost plugins.lua source <afile> | PackerSync
--   augroup end
-- ]]

local present, packer = pcall(require, "packer")
if not present then
  return
end

packer.init {
  auto_clean = true,
  compile_on_sync = true,
  disable_commands = true,
  git = { clone_timeout = 6000 },
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

packer.startup({ function()
  use 'lewis6991/impatient.nvim' -- Startup profiler
  -- packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Colorscheme
  use 'sainnhe/gruvbox-material'
  use 'EdenEast/nightfox.nvim'
  -- use 'cocopon/iceberg.vim'
  -- use 'davidosomething/vim-colors-meh'
  -- use 'kyazdani42/blue-moon'
  -- use { "mcchrish/zenbones.nvim", requires = "rktjmp/lush.nvim"}
  -- use 'fenetikm/falcon'
  -- use 'ishan9299/nvim-solarized-lua'
  -- use 'sainnhe/everforest'
  -- use "rebelot/kanagawa.nvim"
  -- use 'windwp/wind-colors'
  -- use { 'lifepillar/g.uvbox8', opt = true }
  -- use 'ellisonleao/gruvbox.nvim'

  -- Language Support Protocol
  use {
    'neovim/nvim-lspconfig',
    opt = true,
    config = function()
      vim.defer_fn(function()
        vim.cmd "silent! e %"
      end, 0)
    end,
    setup = function()
      lazy "nvim-lspconfig"
    end,
  } -- lsp client
  use { 'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = function()
      require('configs.cmp')
    end,
  } -- autocompletion plugin

  use {
    'l3mon4d3/luasnip',
    after = 'nvim-cmp',
    config = function()
      require('configs.luasnip')
    end,
  } -- snippets plugin

  use {
    'saadparwaiz1/cmp_luasnip',
    after = 'luasnip',
  } -- snippets source for nvim-cmp

  use {
    'hrsh7th/cmp-nvim-lsp',
    after = 'cmp_luasnip',
    config = function()
      require('configs.lsp')
    end,
  } -- lsp source for nvim-cmp

  -- Editing support
  use { 'tpope/vim-surround',
    after = 'nvim-treesitter',
  } -- Surround
  use { 'numToStr/Comment.nvim',
    module = "Comment",
    keys = { "gc", "gb" },
    config = function()
      require("configs.comment")
    end,

    event = 'InsertEnter *',
  } -- Smart comment
  use { 'windwp/nvim-autopairs',
    after = 'nvim-cmp',
    config = function()
      require('nvim-autopairs').setup()
    end,
    event = 'InsertEnter *',
  } -- Autopairs
  -- use { 'ggandor/lightspeed.nvim',
  --   opt = true,
  --   setup = function()
  --     lazy 'lightspeed.nvim'
  --   end,
  -- } -- Motion
  -- use 'tpope/vim-commentary' -- faster code commenting

  -- Git Integration
  -- use 'tpope/vim-fugitive' -- git integration

  -- Treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':tsupdate',
    opt = true,
    setup = function()
      lazy 'nvim-treesitter'
    end,
    config = function()
      require("configs.treesitter")
    end,
  } -- treesitter syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  } -- Additional textobjects for treesitter

  -- Statusline
  use { 'nvim-lualine/lualine.nvim',
    config = function()
      require('configs.lualine')
    end,
  }

  -- Telescope
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } -- fzf native c for telescope
  use { 'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'telescope-fzf-native.nvim',
    },
    setup = function()
      require('configs.telescope_setup')
    end,
    config = function()
      require('configs.telescope')
    end,

    cmd = 'Telescope',
    module = 'telescope',
  } -- fuzzy finder

  -- Terminal Integration
  use { 'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    config = function()
      require('configs.toggleterm')
    end,
  } -- terminal integration

  -- Startup
  use { 'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = function()
      vim.g.startuptime_tries = 10
    end,
  } -- Startuptime
  use {
    'goolord/alpha-nvim',
    config = function()
      require("configs.alpha")
    end,
  };
end,
})
