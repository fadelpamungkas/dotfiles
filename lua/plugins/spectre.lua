return {
	"windwp/nvim-spectre",
	cmd = { "Spectre" },
	keys = {
		{ "<leader>rp", '<cmd>lua require("spectre").open()<CR>', mode = "n" },
		{ "<leader>rw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', mode = "n" },
		{ "<leader>rw", '<esc><cmd>lua require("spectre").open_visual()<CR>', mode = "v" },
		{ "<leader>rf", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', mode = "n" },
	},
}
