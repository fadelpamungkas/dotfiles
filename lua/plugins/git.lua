return {
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		opts = {
			disable_hint = true,
			disable_commit_confirmation = true,
			disable_insert_on_commit = false,
			integrations = { diffview = true },
		},
	},

	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {
			signcolumn = true,
			numhl = false,
		},
	},

	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		opts = { use_icons = false },
	},
}
