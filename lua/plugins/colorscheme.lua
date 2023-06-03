return {
	{
		dir = "~/.config/nvim/falcon2",
		dependencies = "rktjmp/lush.nvim",
	},
	{ "nyoom-engineering/oxocarbon.nvim" },
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			compile = true, -- enable compiling the colorscheme
			undercurl = false, -- enable undercurls
			transparent = true, -- do not set background color
		},
	},
	{
		"sainnhe/gruvbox-material",
		config = function()
			vim.g.gruvbox_material_background = "hard"
		end,
	},
	{
		"sainnhe/sonokai",
		config = function()
			vim.g.sonokai_diagnostic_virtual_text = "colored"
		end,
	},
}
