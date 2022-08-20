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
  use { 'lewis6991/impatient.nvim' } -- Startup profiler
  -- packer can manage itself
  use { 'wbthomason/packer.nvim' }

  -- Colorscheme
  use {
    'EdenEast/nightfox.nvim',
    config = function()
      require('configs.colorscheme')
    end,
  }
  use { 'sainnhe/gruvbox-material' }
  use {
    'VonHeikemen/little-wonder',
    config = function()
      vim.cmd "colorscheme lw-owl"
    end,
  }
  use {
    "mcchrish/zenbones.nvim",
    requires = "rktjmp/lush.nvim",
    config = function()
      vim.cmd "colorscheme zenwritten"
    end,
  }
  use { 'fenetikm/falcon' }
  use {
    'olivercederborg/poimandres.nvim',
    config = function()
      require('poimandres').setup {}
    end
  }
  -- use { 'Yazeed1s/minimal.nvim' }
  -- use { 'Mofiqul/adwaita.nvim' }
  -- use { 'ldelossa/vimdark' }
  -- use { 'ishan9299/modus-theme-vim' }
  -- use { 'kdheepak/monochrome.nvim', config = function()
  --   vim.cmd 'colorscheme monochrome'
  -- end }
  -- use {
  --   "chrsm/paramount-ng.nvim",
  --   requires = { "rktjmp/lush.nvim" }
  -- }
  -- use { "catppuccin/nvim", as = "catppuccin" }
  -- use 'davidosomething/vim-colors-meh'
  -- use 'cocopon/iceberg.vim'
  -- use 'kyazdani42/blue-moon'
  -- use {
  --   'He4eT/desolate.nvim',
  --   requires = { 'rktjmp/lush.nvim' },
  --}
  -- use { 'kvrohit/rasmus.nvim' }
  -- use {
  --   'meliora-theme/neovim',
  --   requires = { 'rktjmp/lush.nvim' },
  --   config = function()
  --     require('meliora').setup({
  --       neutral = true
  --     })
  --   end,
  -- }
  -- use({
  --   'projekt0n/github-nvim-theme',
  --   config = function()
  --     require('github-theme').setup({
  --       -- ...
  --     })
  --   end
  -- })
  --
  -- use { 'RRethy/nvim-base16' }
  -- use({
  --   'rose-pine/neovim',
  --   as = 'rose-pine',
  --   tag = 'v1.*',
  --   config = function()
  --     vim.cmd('colorscheme rose-pine')
  --   end
  -- })
  -- use {
  --   'rockerBOO/boo-colorscheme-nvim',
  --   config = function()
  --     require('boo-colorscheme').use(
  --       { theme = 'sunset_cloud' }
  --     )
  --   end,
  -- }
  -- use { 'wuelnerdotexe/vim-enfocado' }
  -- use { 'frenzyexists/aquarium-vim' }
  -- use { 'bluz71/vim-moonfly-colors' }
  -- use { 'ishan9299/nvim-solarized-lua' }
  -- use { 'sainnhe/everforest' }
  -- use { 'rebelot/kanagawa.nvim' }
  -- use { 'windwp/wind-colors' }
  -- use { 'lifepillar/gruvbox8', opt = true }
  -- use 'ellisonleao/gruvbox.nvim'

  -- Language Support Protocol

  use {
    'williamboman/mason.nvim',
    config = function()
      require("mason").setup()
    end,
  }
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
  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require('configs.null-ls')
    end,
    requires = { "nvim-lua/plenary.nvim" },
  } -- additional language server
  use {
    'hrsh7th/cmp-nvim-lsp',
    -- opt = true,
    config = function()
      require('configs.lsp')
    end,
  } -- lsp source for nvim-cmp

  use {
    "folke/trouble.nvim",
    opt = true,
    config = function()
      require('configs.trouble')
    end,
    setup = function()
      lazy "trouble.nvim"
    end,
  } -- trouble code

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
    "williamboman/nvim-lsp-installer",
    config = function()
      require("nvim-lsp-installer").setup()
    end,
  }

  -- Editing support
  use({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  }) -- cover any code

  use {
    'jinh0/eyeliner.nvim',
    config = function()
      require('configs.eyeliner')
    end,
  } -- fast inline jumps

  use {
    'lukas-reineke/indent-blankline.nvim',
    keys = {
      { "n", "<c-i>" },
    },
    config = function()
      require('configs.indent')
    end,
  } -- Indentation

  use {
    'numToStr/Comment.nvim',
    module = "Comment",
    keys = {
      { "n", "gcc" },
      { "n", "gbc" },
      { "n", "gco" },
      { "n", "gcO" },
      { "n", "gcA" },
      { "x", "gc" },
      { "x", "gb" },
    },
    config = function()
      require("configs.comment")
    end,
  } -- Smart comment

  use {
    'windwp/nvim-autopairs',
    after = 'nvim-cmp',
    config = function()
      require('nvim-autopairs').setup()
    end,
  } -- Autopairs

  use {
    'windwp/nvim-ts-autotag',
    after = 'nvim-cmp',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  }

  -- use { 'ggandor/lightspeed.nvim',
  --   opt = true,
  --   setup = function()
  --     lazy 'lightspeed.nvim'
  --   end,
  -- } -- Motion
  --
  -- use 'tpope/vim-commentary' -- faster code commenting

  -- Git Integration
  use {
    'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim',
    cmd = 'Neogit',
    keys = {
      { "n", "<leader>g" },
    },
    config = function()
      require('configs.neogit')
    end,
  }

  -- use 'tpope/vim-fugitive' -- git integration

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter', run = ':tsupdate',
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

  use {
    'haringsrob/nvim_context_vt',
    config = function()
      require('configs.contextvt')
    end,
  }

  -- Statusline
  use { 'nvim-lualine/lualine.nvim',
    config = function()
      require('configs.lualine')
    end,
  }

  -- SmoothScrolling
  use {
    'declancm/cinnamon.nvim',
    config = function()
      require('configs.cinnamon')
    end
  }

  -- Telescope
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } -- fzf native c for telescope
  use {
    'nvim-telescope/telescope.nvim',
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
  use {
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    keys = {
      { "n", "<c-\\>" },
    },
    config = function()
      require('configs.toggleterm')
    end,
  } -- terminal integration

  -- Explorer
  use {
    'theblob42/drex.nvim',
  }

  -- Startup
  use {
    'dstein64/vim-startuptime',
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
