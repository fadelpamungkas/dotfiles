return {
	"goolord/alpha-nvim",
	lazy = false,
	opts = {
		layout = {
			{ type = "padding", val = 3 },
			{
				type = "text",
				val = {
					"⎮ Preconfigured",
					"⎮ Neovim v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch,
				},
				opts = {
					-- position = "center",
					hl = "Constant",
				},
			},
		},
		opts = {
			margin = 1,
		},
	},
}
