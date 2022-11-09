local present, eyeliner = pcall(require, "eyeliner")
if not present then
	return
end

vim.api.nvim_set_keymap("n", "<leader>l", "<cmd>EyelinerToggle<CR>", { noremap = true })

vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = "#fe8019", bold = true })
vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = "#b8bb26", bold = true })

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "EyelinerPrimary", { bold = true })
	end,
})

eyeliner.setup({
	highlight_on_key = true,
})
