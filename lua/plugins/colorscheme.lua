return {
	{
		"nyoom-engineering/oxocarbon.nvim",
	},
	{
		"Yazeed1s/minimal.nvim",
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
	{
		"sainnhe/gruvbox-material",
		-- priority = 1000,
		-- lazy = false,
		config = function()
			vim.g.gruvbox_material_background = "hard"
			-- vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		"sainnhe/sonokai",
		-- lazy = false,
		-- priority = 1000,
		-- config = function()
		-- 	vim.g.sonokai_style = "atlantis"
		-- 	vim.cmd.colorscheme("sonokai")
		-- 	vim.cmd.colorscheme("falcon")
		-- end,
	},
	-- { 'sainnhe/everforest', priority = 1000 },
	{
		"fenetikm/falcon",
	},
	-- { "kvrohit/rasmus.nvim", priority = 1000 },
	-- { "kvrohit/mellow.nvim", priority = 1000 },
	-- { "davidosomething/vim-colors-meh", priority = 1000 },
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
	-- 	-- tag = "v1.*",
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
	-- {
	-- 	"olivercederborg/poimandres.nvim",
	-- 	config = true,
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
	-- { 'wuelnerdotexe/vim-enfocado' },
	-- { 'frenzyexists/aquarium-vim' },
	-- { "bluz71/vim-moonfly-colors", priority = 1000 },
	{
		"bluz71/vim-nightfly-colors",
	},
	-- { "ishan9299/nvim-solarized-lua" },
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			compile = true, -- enable compiling the colorscheme
			undercurl = false, -- enable undercurls
			commentStyle = { italic = false },
			functionStyle = {},
			keywordStyle = { italic = false },
			statementStyle = { bold = false },
			typeStyle = {},
			transparent = false, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			colors = { -- add/modify theme and palette colors
				palette = {
					-- sumiInk0 = "#000000",
					-- fujiWhite = "#FFFFFF",
				},
				theme = {
					wave = {},
					lotus = {},
					dragon = {
						ui = {
							bg_gutter = "none",
						},
					},
					all = {
						-- ui = {
						-- 	bg_gutter = "none",
						-- },
						-- syn = {
						-- 	identifier = "none",
						-- },
					},
				},
			},
			overrides = function(colors) -- add/modify highlights
				local theme = colors.theme
				return {
					-- Assign a static color to strings
					-- NormalFloat = { fg = theme.ui.float.fg, bg = theme.ui.float.bg },
					TreesitterContext = { link = "Normal" },
					-- theme colors will update dynamically when you change theme!
					-- SomePluginHl = { fg = colors.theme.syn.type, bold = true },
					-- NormalFloat = { bg = "none" },
					-- FloatBorder = { bg = "none" },
					-- FloatTitle = { bg = "none" },

					-- Save an hlgroup with dark background and dimmed foreground
					-- so that you can use it where your still want darker windows.
					-- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
					NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

					-- Popular plugins that open floats will link to NormalFloat by default;
					-- set their background accordingly if you wish to keep them dark and borderless
					-- LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					-- MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },
				}
			end,
			theme = "dragon", -- Load "wave" theme when 'background' option is not set
			background = { -- map the value of 'background' option to a theme
				dark = "dragon", -- try "dragon" !
				light = "lotus",
			},
		},
	},
	-- { 'windwp/wind-colors' },
	-- { "lifepillar/gruvbox8", event = "VeryLazy" },
	-- { 'ellisonleao/gruvbox.nvim' },
}
