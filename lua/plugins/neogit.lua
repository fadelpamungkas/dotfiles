return {
	"TimUntersberger/neogit",
	cmd = "Neogit",
	dependencies = {
		"sindrets/diffview.nvim",
	},
	opts = {
		disable_hint = true,
		disable_commit_confirmation = true,
		disable_insert_on_commit = false,
		integrations = {
			diffview = true,
		},
	},
}
