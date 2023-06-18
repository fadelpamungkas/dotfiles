return {
	-- {
	-- 	dir = "~/.config/nvim/falcon2",
	-- 	dependencies = "rktjmp/lush.nvim",
	-- },
	{
		"svermeulen/text-to-colorscheme.nvim",
		opts = {
			ai = {
				openai_api_key = os.getenv("OPENAI_API_KEY"),
				gpt_model = "gpt-3.5-turbo",
			},
			transparent_mode = false,
			hex_palettes = {
				{
					name = "minimalist",
					background_mode = "dark",
					background = "#1c1c1c",
					foreground = "#d4d4d4",
					accents = {
						"#828282",
						"#8c8c8c",
						"#b3b3b3",
						"#e6e6e6",
						"#7cafc2",
						"#bf616a",
						"#8ba277",
					},
				},
			},
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			-- transparent_background = true,
			show_end_of_buffer = true,
			term_colors = true,
		},
	},
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_foreground = "mix"
		end,
	},
	{ "ellisonleao/gruvbox.nvim", opts = { bold = false, contrast = "hard" } },
	{ "dracula/vim" },
	{ "rebelot/kanagawa.nvim", opts = { compile = true, transparent = false } },
}
