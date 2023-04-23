return {
	-- {
	-- 	"nyoom-engineering/oxocarbon.nvim",
	-- 	priority = 1000,
	-- },
	-- {
	-- 	"Yazeed1s/minimal.nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.g.minimal_transparent_background = true
	-- 	end,
	-- },
	-- {
	-- 	"EdenEast/nightfox.nvim",
	-- 	priority = 1000,
	-- 	opts = {
	-- 		options = {
	-- 			transparent = true, -- Disable setting background
	-- 		},
	-- 	},
	-- },
	-- {
	-- 	"sainnhe/gruvbox-material",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.g.gruvbox_material_background = "hard"
	-- 	end,
	-- },
	-- {
	-- 	"sainnhe/sonokai",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.g.sonokai_transparent_background = 1
	-- 		vim.g.sonokai_diagnostic_text_highlight = 1
	-- 		vim.g.sonokai_diagnostic_line_highlight = 1
	-- 		vim.g.sonokai_diagnostic_virtual_text = "colored"
	-- 	end,
	-- },
	-- {
	-- 	"fenetikm/falcon",
	-- 	priority = 1000,
	-- 	branch = "v3",
	-- 	dependencies = "rktjmp/lush.nvim",
	-- 	config = function()
	-- 		vim.g.falcon_inactive = 0
	-- 		vim.g.falcon_background = 1
	-- 		vim.g.falcon_settings = {
	-- 			variation = "modern",
	-- 		}
	-- 		package.loaded["falcon"] = nil
	-- 		require("lush")(require("falcon").setup())
	-- 	end,
	-- },
	{
		"bluz71/vim-nightfly-colors",
		priority = 1000,
		config = function()
			-- Lua initialization file
			vim.g.nightflyItalics = false
			vim.g.nightflyWinSeparator = 2
			vim.opt.fillchars = {
				horiz = "━",
				horizup = "┻",
				horizdown = "┳",
				vert = "┃",
				vertleft = "┫",
				vertright = "┣",
				verthoriz = "╋",
			}

			-- local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
			-- vim.api.nvim_create_autocmd("ColorScheme", {
			-- 	pattern = "nightfly",
			-- 	callback = function()
			-- 		vim.api.nvim_set_hl(0, "Function", { fg = "#82aaff", bold = true })
			-- 	end,
			-- 	group = custom_highlight,
			-- })
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		opts = {
			compile = true, -- enable compiling the colorscheme
			undercurl = false, -- enable undercurls
			commentStyle = { italic = false },
			functionStyle = {},
			keywordStyle = { italic = false },
			statementStyle = { bold = false },
			typeStyle = {},
			transparent = true, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			colors = { -- add/modify theme and palette colors
				theme = {
					dragon = {},
					all = { ui = { bg_gutter = "none" } },
				},
			},
			overrides = function(colors) -- add/modify highlights
				local wave_colors = require("kanagawa.colors").setup({ theme = "wave" })
				local theme = colors.theme
				return {
					TreesitterContext = { link = "Normal" },
					NormalFloat = { bg = "none" },
					FloatBorder = { bg = "none" },
					FloatTitle = { bg = "none" },
					NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
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
	-- {
	-- 	"loctvl842/monokai-pro.nvim",
	-- 	priority = 1000,
	-- 	opts = {
	-- 		transparent_background = true,
	-- 		terminal_colors = true,
	-- 		devicons = false, -- highlight the icons of `nvim-web-devicons`
	-- 		styles = {
	-- 			comment = { italic = false },
	-- 			keyword = { italic = false }, -- any other keyword
	-- 			type = { italic = false }, -- (preferred) int, long, char, etc
	-- 			storageclass = { italic = false }, -- static, register, volatile, etc
	-- 			structure = { italic = false }, -- struct, union, enum, etc
	-- 			parameter = { italic = false }, -- parameter pass in function
	-- 			annotation = { italic = false },
	-- 			tag_attribute = { italic = false }, -- attribute of tag in reactjs
	-- 		},
	-- 		filter = "octagon", -- classic | octagon | pro | machine | ristretto | spectrum
	-- 	},
	-- },
	-- {
	-- 	"ishan9299/nvim-solarized-lua",
	-- 	priority = 1000,
	-- },
	-- { 'sainnhe/everforest', priority = 1000 },
	-- { "kvrohit/rasmus.nvim", priority = 1000 },
	-- { "kvrohit/mellow.nvim", priority = 1000 },
	-- { "davidosomething/vim-colors-meh", priority = 1000 },
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	-- lazy = false,
	-- 	-- priority = 1000,
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
	-- 			color_overrides = {
	-- 				mocha = {
	-- 					base = "#000000",
	-- 				},
	-- 			},
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
	-- 	name = "rose-pine",
	-- 	-- tag = "v1.*",
	-- 	opts = {
	-- 		variant = "main",
	-- 		dark_variant = "main",
	-- 		bold_vert_split = false,
	-- 		dim_nc_background = false,
	-- 		disable_background = true,
	-- 		disable_float_background = false,
	-- 		disable_italics = true,
	-- 	},
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
	-- { "bluz71/vim-moonfly-colors" },
	-- { 'windwp/wind-colors' },
	-- { "lifepillar/gruvbox8", event = "VeryLazy" },
	-- { 'ellisonleao/gruvbox.nvim' },
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	-- cond = vim.fn.hostname() == 'alpha',
	-- 	config = function()
	-- 		require("tokyonight").setup({
	-- 			style = "night",
	-- 		})
	-- 	end,
	-- },
}
