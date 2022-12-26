return {
	"jinh0/eyeliner.nvim",
	cmd = { "Eyeliner", "EyelinerToggle" },
	config = function()
		local eyeliner = require("eyeliner")

		vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = "#fe8019", bold = true })
		vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = "#b8bb26", bold = true })

		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				vim.api.nvim_set_hl(0, "EyelinerPrimary", { bold = true })
			end,
		})

		eyeliner.setup({
			highlight_on_key = true
		})
	end,
}
