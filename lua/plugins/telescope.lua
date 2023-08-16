return {

	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		-- enabled = false,
		keys = {
			{ "<leader>f", "<cmd>Telescope find_files<CR>" },
			{ "<leader>F", "<cmd>Telescope oldfiles<CR>" },
			{ "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>" },
			{ "<leader>S", "<cmd>Telescope live_grep<CR>" },
			{ "<leader>b", "<cmd>Telescope buffers<CR>" },
			{ "<leader>o", "<cmd>Telescope lsp_document_symbols<CR>" },
			{ "<leader>,", "<cmd>Telescope resume<CR>" },
		},
		dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
		config = function()
			require("telescope").setup({
				defaults = {
					sorting_strategy = "ascending",
					results_title = false,
					file_ignore_patterns = { "node_modules" },
					layout_config = { prompt_position = "top" },
					mappings = {
						n = {
							["o"] = require("telescope.actions").select_default,
							["q"] = require("telescope.actions").close,
							["p"] = require("telescope.actions.layout").toggle_preview,
							["t"] = require("trouble.providers.telescope").open_with_trouble,
							["h"] = function(tb)
								require("telescope.actions").drop_all(tb)
								require("telescope.actions").add_selection(tb)
								require("telescope.actions.utils").map_selections(tb, function(selection)
									pcall(require("harpoon.mark").add_file, selection[1])
								end)
								require("telescope.actions").remove_selection(tb)
							end,
						},
					},
				},
			})
			require("telescope").load_extension("fzf")
		end,
	},
}
