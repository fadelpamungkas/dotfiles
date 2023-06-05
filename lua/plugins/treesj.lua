return {
	"Wansmer/treesj",
	keys = {
		{
			"<leader>n",
			function()
				require("treesj").toggle({ split = { recursive = true } })
			end,
		},
		{
			"<leader>j",
			function()
				require("treesj").join()
			end,
		},
		{
			"<leader>J",
			function()
				require("treesj").split()
			end,
		},
	},
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("treesj").setup({ use_default_keymaps = false })
	end,
}
