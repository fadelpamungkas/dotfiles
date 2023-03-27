return {
	"ckolkey/ts-node-action",
	dependencies = { "nvim-treesitter" },
	keys = {
		{
			"<leader>K",
			function()
				require("ts-node-action").node_action()
			end,
			desc = "ts-node-action",
		},
	},
	config = true,
}
