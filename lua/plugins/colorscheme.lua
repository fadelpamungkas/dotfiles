return {
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
    priority = 1000,
		config = function()
			vim.cmd.colorscheme("oxocarbon")
		end,
	},
	{
		"Yazeed1s/minimal.nvim",
		-- lazy = false,
		-- config = function()
		-- 	vim.cmd.colorscheme("minimal-base16")
		-- end,
	},
	{
		"EdenEast/nightfox.nvim",
		opts = {
			options = {
				-- Compiled file's destination location
				compile_path = vim.fn.stdpath("cache") .. "/nightfox",
				compile_file_suffix = "_compiled", -- Compiled file suffix
				transparent = false, -- Disable setting background
				terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
				dim_inactive = false, -- Non focused panes set to alternative background
				styles = { -- Style to be applied to different syntax groups
					comments = "italic", -- Value is any valid attr-list value `:help attr-list`
					conditionals = "NONE",
					constants = "NONE",
					functions = "NONE",
					keywords = "NONE",
					numbers = "NONE",
					operators = "NONE",
					strings = "NONE",
					types = "NONE",
					variables = "NONE",
				},
				inverse = { -- Inverse highlight for different types
					match_paren = false,
					visual = false,
					search = false,
				},
				modules = { -- List of various plugins and additional options
					-- ...
				},
			},
			palettes = {
				nightfox = {
					-- A specific style's value will be used over the `all`'s value
					-- red = "#c94f6d",
					-- comment = "#60728a",
				},
			},
			specs = {
				nightfox = {
					syntax = {
						bracket = "white.dim",
						builtin0 = "blue",
						builtin1 = "white.dim",
						builtin2 = "yellow",
						-- comment = "",
						conditional = "blue",
						-- const = "",
						-- dep = "",
						field = "white.dim",
						func = "white",
						ident = "cyan",
						keyword = "blue",
						-- number = "",
						-- operator = "",
						preproc = "red",
						-- regex = "",
						-- statement = "",
						string = "green",
						type = "white.dim",
						variable = "white.dim",
					},
				},
			},
			groups = {},
		},
	},
	-- { "sainnhe/gruvbox-material", event = "VeryLazy" },
	-- { "fenetikm/falcon", event = "VeryLazy" },
	-- { "kvrohit/rasmus.nvim", event = "VeryLazy" },
	-- { "kvrohit/mellow.nvim", event = "VeryLazy" },
	-- { "davidosomething/vim-colors-meh", event = "VeryLazy" },
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("catppuccin").setup({
	-- 			flavour = "mocha", -- latte, frappe, macchiato, mocha
	-- 			term_colors = true,
	-- 			transparent_background = true,
	-- 			no_italic = true,
	-- 			no_bold = true,
	-- 			styles = {
	-- 				comments = {},
	-- 				conditionals = {},
	-- 				loops = {},
	-- 				functions = {},
	-- 				keywords = {},
	-- 				strings = {},
	-- 				variables = {},
	-- 				numbers = {},
	-- 				booleans = {},
	-- 				properties = {},
	-- 				types = {},
	-- 			},
	-- 			-- color_overrides = {
	-- 			-- 	mocha = {
	-- 			-- 		base = "#000000",
	-- 			-- 	},
	-- 			-- },
	-- 			-- highlight_overrides = {
	-- 			-- 	mocha = function(C)
	-- 			-- 		return {
	-- 			-- 			TabLineSel = { bg = C.pink },
	-- 			-- 			NvimTreeNormal = { bg = C.none },
	-- 			-- 			CmpBorder = { fg = C.surface2 },
	-- 			-- 			Pmenu = { bg = C.none },
	-- 			-- 			NormalFloat = { bg = C.none },
	-- 			-- 			TelescopeBorder = { link = "FloatBorder" },
	-- 			-- 		}
	-- 			-- 	end,
	-- 			-- },
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"jesseleite/nvim-noirbuddy",
	-- 	event = "VeryLazy",
	-- 	dependencies = { "tjdevries/colorbuddy.nvim", branch = "dev" },
	-- 	config = function()
	-- 		require("noirbuddy").setup({
	-- 			preset = "slate",
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"rose-pine/neovim",
	-- 	as = "rose-pine",
	-- 	tag = "v1.*",
	-- },
	-- { "aktersnurra/no-clown-fiesta.nvim", event = "VeryLazy" },
	-- { "VonHeikemen/little-wonder", event = "VeryLazy" },
	-- {
	-- 	"mcchrish/zenbones.nvim",
	-- 	dependencies = "rktjmp/lush.nvim",
	-- 	event = "VeryLazy",
	-- },
	--  { 'vimoxide/vim-cinnabar' },
	--  { 'pbrisbin/vim-colors-off' },
	--  { 'andreypopp/vim-colors-plain' },
	--  {
	--   'olivercederborg/poimandres.nvim',
	--   config = function
	--     require('poimandres').setup {}
	--   end
	-- },
	--  { 'Mofiqul/adwaita.nvim' },
	--  { 'ldelossa/vimdark' },
	--  { 'ishan9299/modus-theme-vim' },
	--  { 'kdheepak/monochrome.nvim', config = function()
	--   vim.cmd 'colorscheme monochrome'
	-- end },
	--  {
	--   "chrsm/paramount-ng.nvim",
	--   requires = { "rktjmp/lush.nvim" }
	-- },
	--  'cocopon/iceberg.vim',
	--  'kyazdani42/blue-moon',
	--  {
	--   'He4eT/desolate.nvim',
	--   requires = { 'rktjmp/lush.nvim' },
	--},
	--  { 'kvrohit/rasmus.nvim' },
	--  {
	--   'meliora-theme/neovim',
	--   requires = { 'rktjmp/lush.nvim' },
	--   config = function()
	--     require('meliora').setup({
	--       neutral = true
	--     })
	--   end,
	-- },
	-- {
	-- 	"projekt0n/github-nvim-theme",
	-- 	config = function()
	-- 		require("github-theme").setup({
	-- 			-- ...
	-- 		})
	-- 	end,
	-- },
	--
	-- { "RRethy/nvim-base16", event = "VeryLazy" },
	--  {
	--   'rockerBOO/boo-colorscheme-nvim',
	--   config = function()
	--     require('boo-colorscheme').(
	--       { theme = 'sunset_cloud' }
	--     )
	--   end,
	-- },
	--  { 'wuelnerdotexe/vim-enfocado' },
	--  { 'frenzyexists/aquarium-vim' },
	--  { 'bluz71/vim-moonfly-colors' },
	--  { 'ishan9299/nvim-solarized-lua' },
	--  { 'sainnhe/everforest' },
	-- {
	-- 	"rebelot/kanagawa.nvim",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("kanagawa").setup({
	-- 			compile = false, -- enable compiling the colorscheme
	-- 			undercurl = false, -- enable undercurls
	-- 			commentStyle = { italic = true },
	-- 			functionStyle = {},
	-- 			keywordStyle = {},
	-- 			statementStyle = {},
	-- 			typeStyle = {},
	-- 			transparent = false, -- do not set background color
	-- 			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
	-- 			terminalColors = true, -- define vim.g.terminal_color_{0,17}
	-- 			colors = { -- add/modify theme and palette colors
	-- 				palette = {},
	-- 				theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
	-- 			},
	-- 			overrides = function(colors) -- add/modify highlights
	-- 				return {}
	-- 			end,
	-- 			theme = "wave", -- Load "wave" theme when 'background' option is not set
	-- 			background = { -- map the value of 'background' option to a theme
	-- 				dark = "wave", -- try "dragon" !
	-- 				light = "lotus",
	-- 			},
	-- 		})
	-- 	end,
	-- },
	--  { 'windwp/wind-colors' },
	-- { "lifepillar/gruvbox8", event = "VeryLazy" },
	--  'ellisonleao/gruvbox.nvim',
}
