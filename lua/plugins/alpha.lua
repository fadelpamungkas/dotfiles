return {
	"goolord/alpha-nvim",
	lazy = false,
	opts = {
		layout = {
			{
				type = "group",
				val = {
					{ type = "padding", val = 20 },
					{
						type = "text",
						val = {
							"Preconfigured NVIM "
								.. "v"
								.. vim.version().major
								.. "."
								.. vim.version().minor
								.. "."
								.. vim.version().patch
								.. " - "
								.. require("lazy").stats().count
								.. " plugins",
						},
						opts = {
							position = "center",
							hl = "Function",
						},
					},
					{ type = "padding", val = 1 },
					{
						type = "text",
						val = {
							"Nvim is open source and freely distributable",
							"          https://neovim.io/#chat",
						},
						opts = {
							position = "center",
						},
					},
					{ type = "padding", val = 1 },
					{
						type = "text",
						val = {
							"type :help nvim             if you are new!",
							"type :checkhealth           to optimize Nvim",
							"type :q                     to exit",
							"type :help                  for help",
						},
						opts = {
							position = "center",
						},
					},
					{ type = "padding", val = 1 },
					{
						type = "text",
						val = {
							"               forkable on",
							"https://github.com/fadelpamungkas/dotfiles",
						},
						opts = {
							position = "center",
						},
					},
				},
				opts = {
					position = "center",
				},
			},
		},
		opts = { noautocmd = true },
	},
}
