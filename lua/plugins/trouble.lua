return {
	"folke/trouble.nvim",
	cmd = { "TroubleToggle", "Trouble" },
	keys = {
		{ "<leader>d", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
	},
	opts = {
		icons = false,
		fold_open = "v",
		fold_closed = ">",
		indent_lines = false,
		use_diagnostic_signs = true,
		padding = false,
		action_keys = {
			open_split = { "s" },
			open_vsplit = { "v" },
			open_tab = { "<c-t>" },
			close_folds = { "c", "zm" },
			open_folds = { "e", "zr" },
			toggle_fold = { "zA", "za" },
		},
	},
}
