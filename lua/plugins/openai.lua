return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		panel = { keymap = { open = "<C-CR>" } },
		filetypes = { yaml = true, markdown = true },
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
	},
}
