return {
	-- {
	-- 	dir = "~/.config/nvim/board",
	-- 	dependencies = "rktjmp/lush.nvim",
	-- },
	-- {
	-- 	dir = "~/.config/nvim/min",
	-- 	dependencies = "rktjmp/lush.nvim",
	-- },
	-- {
	-- 	dir = "~/.config/nvim/falcon2",
	-- 	dependencies = "rktjmp/lush.nvim",
	-- },
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			compile = true,
			keywordStyle = { italic = false },
			statementStyle = { bold = false },
			transparent = true,
			colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
		},
	},
	{
		"dracula/vim",
		config = function()
			vim.g.dracula_colorterm = 0
		end,
	},
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {
	-- 		transparent_background = true,
	-- 		show_end_of_buffer = true,
	-- 		term_colors = true,
	-- 	},
	-- },
	-- {
	-- 	"ellisonleao/gruvbox.nvim",
	-- 	opts = {
	-- 		bold = false,
	-- 		contrast = "hard",
	-- 		transparent_mode = true,
	-- 	},
	-- },
	-- { "andreypopp/vim-colors-plain" },
	-- { "olivercederborg/poimandres.nvim", opts = { disable_background = true, disable_italics = true } },
	-- {
	-- 	"sainnhe/gruvbox-material",
	-- 	config = function()
	-- 		-- vim.g.gruvbox_material_background = "hard"
	-- 		vim.g.gruvbox_material_foreground = "mix"
	-- 		vim.g.gruvbox_material_transparent_background = 1
	-- 	end,
	-- },
}
