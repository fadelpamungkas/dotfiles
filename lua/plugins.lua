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

packer.init({
	auto_clean = true,
	compile_on_sync = true,
	disable_commands = true,
	git = { clone_timeout = 6000 },
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

packer.startup({
	function()
		use({ "lewis6991/impatient.nvim" }) -- Startup profiler
		-- packer can manage itself
		use({ "wbthomason/packer.nvim" })

		-- Colorscheme
		use({
			"shaunsingh/oxocarbon.nvim",
			branch = "fennel",
			config = function()
				vim.cmd.colorscheme("oxocarbon")
				-- vim.cmd 'hi NormalFloat guibg=#262625'
			end,
		})
		use({
			"EdenEast/nightfox.nvim",
			config = function()
				require("configs.colorscheme")
			end,
		})
		use({ "aktersnurra/no-clown-fiesta.nvim" })
		-- use { 'sainnhe/gruvbox-material' }
		-- use { 'VonHeikemen/little-wonder' }
		-- use {
		--   "mcchrish/zenbones.nvim",
		--   requires = "rktjmp/lush.nvim",
		-- }
		-- use { 'vimoxide/vim-cinnabar' }
		-- use { 'pbrisbin/vim-colors-off' }
		-- use { 'andreypopp/vim-colors-plain' }
		-- use { 'B4mbus/oxocarbon-lua.nvim' }
		-- use { 'fenetikm/falcon' }
		-- use {
		--   'olivercederborg/poimandres.nvim',
		--   config = function()
		--     require('poimandres').setup {}
		--   end
		-- }
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
		use({
			event = "InsertEnter",
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
			end,
		})
		use({
			after = "mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		})
		use({
			"neovim/nvim-lspconfig",
			after = "mason-lspconfig.nvim",
			config = function()
				require("configs.lsp")
			end,
			-- opt = true,
			-- config = function()
			--   vim.defer_fn(function()
			--     vim.cmd "silent! e %"
			--   end, 0)
			-- end,
			-- setup = function()
			--   lazy "nvim-lspconfig"
			-- end,
		})
		use({
			"jose-elias-alvarez/null-ls.nvim",
			after = "nvim-cmp",
			config = function()
				require("configs.null-ls")
			end,
			requires = { "nvim-lua/plenary.nvim" },
		})
		use({
			"hrsh7th/cmp-nvim-lsp",
			-- opt = true,
		})

		use({
			"folke/trouble.nvim",
			opt = true,
			config = function()
				require("configs.trouble")
			end,
			setup = function()
				lazy("trouble.nvim")
			end,
		})

		use({
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			config = function()
				require("configs.cmp")
			end,
		})

		use({
			"l3mon4d3/luasnip",
			after = "nvim-cmp",
			config = function()
				require("configs.luasnip")
			end,
		})

		use({
			"saadparwaiz1/cmp_luasnip",
			after = "luasnip",
		})

		use({
			"hrsh7th/cmp-buffer",
			after = "nvim-cmp",
		})

		use({
			"hrsh7th/cmp-path",
			after = "nvim-cmp",
		})

		use({
			"j-hui/fidget.nvim",
			config = function()
				require("fidget").setup()
			end,
		})

		use({
			"ray-x/lsp_signature.nvim",
		})

		-- Editing support
		use({
			"kylechui/nvim-surround",
			config = function()
				require("nvim-surround").setup()
			end,
		})

		use({
			"jinh0/eyeliner.nvim",
			-- cmd = 'EyelinerToggle',
			config = function()
				require("configs.eyeliner")
			end,
		})

		use({
			"numToStr/Comment.nvim",
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
		})

		use({
			"windwp/nvim-autopairs",
			after = "nvim-cmp",
			config = function()
				require("nvim-autopairs").setup()
			end,
		})

		use({
			"windwp/nvim-ts-autotag",
			after = "nvim-cmp",
			config = function()
				require("nvim-ts-autotag").setup()
			end,
		})

		-- Motion
		-- use {
		--   'phaazon/hop.nvim',
		--   branch = 'v2', -- optional but strongly recommended
		--   config = function()
		--     require('configs.hop')
		--   end
		-- }
		use({
			"ggandor/leap.nvim",
			config = function()
				require("leap").add_default_mappings()
				vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
			end,
		})

		-- Git Integration
		use({
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup()
			end,
		})
		use({
			"TimUntersberger/neogit",
			requires = {
				"nvim-lua/plenary.nvim",
				"sindrets/diffview.nvim",
			},
			cmd = "Neogit",
			config = function()
				require("configs.neogit")
			end,
		})

		-- Treesitter
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":tsupdate",
			opt = true,
			setup = function()
				lazy("nvim-treesitter")
			end,
			config = function()
				require("configs.treesitter")
			end,
		})

		use({
			"nvim-treesitter/nvim-treesitter-textobjects",
			after = "nvim-treesitter",
		})

		use({
			"haringsrob/nvim_context_vt",
			config = function()
				require("configs.contextvt")
			end,
			cmd = "NvimContextVtToggle",
		})

		-- Statusline
		use({
			"nvim-lualine/lualine.nvim",
			after = {
				"nvim-cmp",
				"lualine-lsp-progress",
			},
			config = function()
				require("configs.lualine")
			end,
		})

		use({ "arkav/lualine-lsp-progress" })

		-- SmoothScrolling
		use({
			"karb94/neoscroll.nvim",
			config = function()
				require("configs.neoscroll")
			end,
		})

		-- Fuzzy finder
		use({
			"nvim-telescope/telescope-fzf-native.nvim",
			run = "make",
		})
		use({
			"nvim-telescope/telescope.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
				"telescope-fzf-native.nvim",
			},
			setup = function()
				require("configs.telescope_setup")
			end,
			config = function()
				require("configs.telescope")
			end,
			cmd = "Telescope",
			module = "telescope",
		})

		-- Terminal Integration
		use({
			"akinsho/toggleterm.nvim",
			cmd = "ToggleTerm",
			keys = {
				{ "n", "<c-\\>" },
			},
			config = function()
				require("configs.toggleterm")
			end,
		})

		-- Explorer
		use({
			"elihunter173/dirbuf.nvim",
			cmd = "Dirbuf",
			keys = {
				{ "n", "<leader>e" },
			},
			config = function()
				require("configs.dirbuf")
			end,
		})

		-- Misc
		use({
			"nagy135/typebreak.nvim",
			requires = "nvim-lua/plenary.nvim",
			module = "typebreak",
		})
		use({
			"anuvyklack/hydra.nvim",
			keys = {
				{ "n", "<leader>t" },
				{ "n", "<leader>a" },
				{ "n", "<leader>g" },
			},
			config = function()
				require("configs.hydra")
			end,
		})

		-- Code Outline
		use({
			"simrat39/symbols-outline.nvim",
			cmd = "SymbolsOutline",
			config = function()
				require("configs.symbols-outline")
			end,
		})

		-- Startup
		use({
			"dstein64/vim-startuptime",
			cmd = "StartupTime",
			config = function()
				vim.g.startuptime_tries = 10
			end,
		})
		use({
			"goolord/alpha-nvim",
			config = function()
				require("configs.alpha")
			end,
		})
	end,
})
