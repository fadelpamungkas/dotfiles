return {
	{
		"rebelot/kanagawa.nvim",
		opts = {
			compile = true,
			keywordStyle = { italic = false },
			statementStyle = { bold = false },
			transparent = true,
			colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			transparent_background = true,
			show_end_of_buffer = true,
			term_colors = true,
		},
	},
	{
		"projekt0n/github-nvim-theme",
		lazy = false,
		priority = 1000,
		config = function()
			require("github-theme").setup({
				options = {
					hide_end_of_buffer = false,
					transparent = true,
					terminal_colors = true,
				},
			})
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		opts = { bold = false },
	},
	{
		dir = "~/.config/nvim/board",
		dependencies = "rktjmp/lush.nvim",
	},
	{
		"rose-pine/neovim",
		lazy = false,
		priority = 1000,
		name = "rose-pine",
		opts = {
			disable_background = true,
			disable_float_background = false,
			disable_italics = true,
		},
	},
}
