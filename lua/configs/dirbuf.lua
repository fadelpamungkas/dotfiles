local present, dirbuf = pcall(require, "dirbuf")
if not present then
	return
end

vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>Dirbuf<CR>", { noremap = true })

dirbuf.setup({
	hash_padding = 2,
	show_hidden = true,
	sort_order = "directories_first",
	write_cmd = "DirbufSync",
})
