return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		event = "VeryLazy",
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- latte, frappe, macchiato, mocha
				term_colors = true,
				transparent_background = false,
				no_italic = false,
				no_bold = false,
				styles = {
					comments = {},
					conditionals = {},
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
				},
				color_overrides = {
					mocha = {
						base = "#000000",
					},
				},
				highlight_overrides = {
					mocha = function(C)
						return {
							TabLineSel = { bg = C.pink },
							NvimTreeNormal = { bg = C.none },
							CmpBorder = { fg = C.surface2 },
							Pmenu = { bg = C.none },
							NormalFloat = { bg = C.none },
							TelescopeBorder = { link = "FloatBorder" },
						}
					end,
				},
			})
		end,
	},
	-- {
	-- 	"jesseleite/nvim-noirbuddy",
	-- 	event = "VeryLazy",
	-- 	dependencies = { "tjdevries/colorbuddy.nvim", branch = "dev" },
	-- 	config = function()
	-- 		require("noirbuddy").setup({
	-- 			preset = "kiwi",
	-- 		})
	-- 	end,
	-- },
	-- { "sainnhe/gruvbox-material" },
	-- {
	-- 	"rose-pine/neovim",
	-- 	as = "rose-pine",
	-- 	tag = "v1.*",
	-- },
	-- { "aktersnurra/no-clown-fiesta.nvim" }
	--  { 'VonHeikemen/little-wonder' }
	--  {
	--   "mcchrish/zenbones.nvim",
	--   requires = "rktjmp/lush.nvim",
	-- },
	--  { 'vimoxide/vim-cinnabar' },
	--  { 'pbrisbin/vim-colors-off' },
	--  { 'andreypopp/vim-colors-plain' },
	--  { 'fenetikm/falcon' },
	--  {
	--   'olivercederborg/poimandres.nvim',
	--   config = function
	--     require('poimandres').setup {}
	--   end
	-- },
	--  { 'Yazeed1s/minimal.nvim' },
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
	--  'davidosomething/vim-colors-meh',
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
	--  { 'RRethy/nvim-base16' },
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
	--  { 'rebelot/kanagawa.nvim' },
	--  { 'windwp/wind-colors' },
	--  { 'lifepillar/gruvbox8', opt = true },
	--  'ellisonleao/gruvbox.nvim',
}
