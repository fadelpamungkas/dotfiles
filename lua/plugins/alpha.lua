return {
	"goolord/alpha-nvim",
	lazy = false,
	opts = {
		layout = {
			{ type = "padding", val = 5 },
			{
				type = "text",
				val = {
					"Preconfigured neovim",
					"v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch,
				},
				opts = {
					-- position = "center",
					hl = "Function",
				},
			},
		},
		opts = {
			margin = 3,
		},
	},
}
