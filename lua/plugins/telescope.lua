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
					winblend = 0,
					prompt_title = "",
					preview_title = "",
					selection_caret = "",
					entry_prefix = "",
					multi_icon = "",
					color_devicons = false,
					-- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
					-- preview = { msg_bg_fillchar = " " },
					layout_config = {
						prompt_position = "top",
						preview_width = 0.5,
						-- anchor = "N",
						-- width = 0.8,
						-- height = 0.8,
						-- preview_cutoff = 120,
					},
					sorting_strategy = "ascending",
					layout_strategy = "horizontal",
					results_title = "",
					file_ignore_patterns = { "node_modules", ".pyc" },
					prompt_prefix = ":",
					-- preview = false,
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
