return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		panel = {
			keymap = {
				open = "<C-CR>",
			},
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = "<C-s>",
				next = "<C-]>",
				prev = "<C-[>",
				dismiss = "<C-\\>",
			},
		},
		filetypes = {
			yaml = true,
			markdown = true,
		},
	},
}
