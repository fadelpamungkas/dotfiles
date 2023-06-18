return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	keys = {
		{ "<leader>f", "<cmd>Telescope find_files find_command=rg,--files<CR>" },
		{ "<leader>F", "<cmd>Telescope oldfiles<CR>" },
		{ "<leader>s", "<cmd>Telescope current_buffer_fuzzy_find<CR>" },
		{ "<leader>S", "<cmd>Telescope live_grep<CR>" },
		{ "<leader>b", "<cmd>Telescope buffers<CR>" },
		{ "<leader>m", "<cmd>Telescope zoxide list<CR>" },
	},
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "jvgrootveld/telescope-zoxide" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local trouble = require("trouble.providers.telescope")

		require("telescope.pickers.layout_strategies").buffer_window = function(self)
			local layout = require("telescope.pickers.window").get_initial_window_options(self)
			local prompt = layout.prompt
			local results = layout.results
			local preview = layout.preview
			local config = self.layout_config
			local padding = self.window.border and 2 or 0
			local width = vim.api.nvim_win_get_width(self.original_win_id)
			local height = vim.api.nvim_win_get_height(self.original_win_id)
			local pos = vim.api.nvim_win_get_position(self.original_win_id)
			local wline = pos[1] + 1
			local wcol = pos[2] + 1

			-- Height
			prompt.height = 1
			preview.height = self.previewer and math.floor(height * 0.6) or 0
			results.height = height
				- padding
				- (prompt.height + padding)
				- (self.previewer and (preview.height + padding) or 0)

			-- Line
			local rows = {}
			local mirror = true -- == config.mirror
			local top_prompt = true -- == config.prompt_position
			if mirror and top_prompt then
				rows = { prompt, results, preview }
			elseif mirror and not top_prompt then
				rows = { results, prompt, preview }
			elseif not mirror and top_prompt then
				rows = { preview, prompt, results }
			elseif not mirror and not top_prompt then
				rows = { preview, results, prompt }
			end
			local next_line = 1 + padding / 2
			for k, v in pairs(rows) do
				if v.height ~= 0 then
					v.line = next_line
					next_line = v.line + padding + v.height
				end
			end

			-- Width
			prompt.width = width - padding
			results.width = prompt.width
			preview.width = prompt.width

			-- Col
			prompt.col = wcol + padding / 2
			results.col = prompt.col
			preview.col = prompt.col

			if not self.previewer then
				layout.preview = nil
			end

			return layout
		end

		telescope.setup({
			extensions = {},
			defaults = {
				layout_strategy = "buffer_window",
				file_ignore_patterns = { "node_modules" },
				initial_mode = "normal",
				border = false,
				sorting_strategy = "ascending",
				preview = { hide_on_startup = true },
				layout_config = { bottom_pane = { height = 10 } },
				mappings = {
					n = {
						["o"] = require("telescope.actions").select_default,
						["q"] = require("telescope.actions").close,
						["p"] = require("telescope.actions.layout").toggle_preview,
						["t"] = trouble.open_with_trouble,
					},
					i = {
						["<c-o>"] = require("telescope.actions").select_default,
						["<c-j>"] = require("telescope.actions").move_selection_next,
						["<c-k>"] = require("telescope.actions").move_selection_previous,
						["<c-p>"] = require("telescope.actions.layout").toggle_preview,
						["<c-t>"] = trouble.open_with_trouble,
					},
				},
			},
			pickers = {
				find_files = {
					prompt_prefix = "File> ",
				},
				oldfiles = {
					prompt_prefix = "Old File> ",
				},
				live_grep = {
					initial_mode = "insert",
					prompt_prefix = "Live Grep> ",
				},
				current_buffer_fuzzy_find = {
					initial_mode = "insert",
					prompt_prefix = "Fuzzy Find> ",
				},
				colorscheme = {
					layout_strategy = "bottom_pane",
					prompt_prefix = "Colorscheme> ",
					enable_preview = true,
				},
				buffers = {
					prompt_prefix = "Buffers> ",
					sort_lastuseed = true,
					ignore_current_buffer = true,
					only_cwd = true,
					mappings = { n = { ["d"] = "delete_buffer" } },
				},
			},
		})
		telescope.load_extension("fzf")
		telescope.load_extension("zoxide")
	end,
}
