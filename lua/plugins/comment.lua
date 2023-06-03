return {
	"numToStr/Comment.nvim",
	keys = {
		{ "gcc", mode = "n" },
		{ "gbc", mode = "n" },
		{ "gco", mode = "n" },
		{ "gcO", mode = "n" },
		{ "gcA", mode = "n" },
		{ "gc", mode = "x" },
		{ "gb", mode = "x" },
	},
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	opts = function()
		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end,
}
