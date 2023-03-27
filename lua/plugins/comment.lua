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
			padding = true,
			sticky = true,
			ignore = nil,
			toggler = {
				line = "gcc",
				block = "gbc",
			},
			opleader = {
				line = "gc",
				block = "gb",
			},
			extra = {
				above = "gcO",
				below = "gco",
				eol = "gcA",
			},
			mappings = {
				basic = true,
				extra = true,
			},
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			post_hook = nil,
		})
	end,
}
