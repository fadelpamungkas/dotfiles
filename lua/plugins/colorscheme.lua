return {
	{
		dir = "~/.config/nvim/falcon2",
		priority = 1000,
		dependencies = "rktjmp/lush.nvim",
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
			transparent = false, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			colors = { -- add/modify theme and palette colors
				theme = { all = { ui = { bg_gutter = "none" } } },
			},
			theme = "dragon", -- Load "wave" theme when 'background' option is not set
			background = { -- map the value of 'background' option to a theme
				dark = "dragon", -- try "dragon" !
				light = "lotus",
			},
		},
	},
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_background = "hard"
		end,
	},
	{
		"nyoom-engineering/oxocarbon.nvim",
		priority = 1000,
	},
	-- {
	-- 	"fenetikm/falcon",
	-- 	priority = 1000,
	-- 	branch = "v3",
	-- 	dependencies = "rktjmp/lush.nvim",
	-- },
}
