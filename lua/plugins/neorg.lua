return {
	{
		"nvim-neorg/neorg",
		ft = "norg",
		build = ":Neorg sync-parsers",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.completion"] = {
					config = { engine = "nvim-cmp" },
				},
				["core.integrations.nvim-cmp"] = {},

				["core.dirman"] = { -- Manages Neorg workspaces
					config = {
						workspaces = {
							notes = "~/notes",
						},
					},
				},
			},
		},
	},
}
