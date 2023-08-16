return {
	{
		"rebelot/kanagawa.nvim",
		opts = {
			compile = true,
			keywordStyle = { italic = false },
			statementStyle = { bold = false },
			transparent = true,
			-- colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
		},
	},
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		name = "catppuccin",
		opts = {
			transparent_background = true,
			show_end_of_buffer = true,
			term_colors = true,
		},
	},
	-- {
	-- 	dir = "~/.config/nvim/board",
	-- 	dependencies = "rktjmp/lush.nvim",
	-- },
	-- { "ellisonleao/gruvbox.nvim", opts = { bold = false } },
	-- {
	-- 	"dracula/vim",
	-- 	config = function()
	-- 		vim.g.dracula_colorterm = 0
	-- 	end,
	-- },
}
