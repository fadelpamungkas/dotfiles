return {
	{
		"ggandor/leap.nvim",
		keys = { "s", "S", "gs" },
		config = function()
			require("leap").add_default_mappings(true)
		end,
	},

	{
		"ggandor/flit.nvim",
		keys = {
			{ "f", mode = { "n", "x", "o" } },
			{ "F", mode = { "n", "x", "o" } },
			{ "t", mode = { "n", "x", "o" } },
			{ "T", mode = { "n", "x", "o" } },
		},
		opts = { labeled_modes = "nxo" },
	},
}
