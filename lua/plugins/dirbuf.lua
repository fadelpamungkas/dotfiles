return {
	"elihunter173/dirbuf.nvim",
  enabled = false,
	cmd = "Dirbuf",
	init = function()
		vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>Dirbuf<CR>", { noremap = true })
	end,
	config = function()
		require("dirbuf").setup({
			hash_padding = 2,
			show_hidden = true,
			sort_order = "directories_first",
			write_cmd = "DirbufSync",
		})
	end,
}
