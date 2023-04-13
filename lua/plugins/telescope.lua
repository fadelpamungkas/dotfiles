local M = {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	keys = {
		{ "<leader>f", "<cmd>Telescope find_files find_command=rg,--ignore,--files<CR>" },
		{ "<leader>F", "<cmd>Telescope oldfiles<CR>" },
		{ "<leader>s", "<cmd>Telescope current_buffer_fuzzy_find<CR>" },
		{ "<leader>S", "<cmd>Telescope live_grep<CR>" },
		{ "<leader>b", "<cmd>Telescope buffers<CR>" },
		{ "<leader>R", "<cmd>Telescope registers<CR>" },
		{ "<leader>c", "<cmd>Telescope command_history<CR>" },
		{
			"<leader>m",
			function()
				require("telescope").extensions.project.project({})
			end,
			desc = "Find Project",
		},
	},
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-project.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
}

function M.config()
	local telescope = require("telescope")
	local trouble = require("trouble.providers.telescope")
	Buffer_window()

	telescope.setup({
		extensions = {},
		defaults = {
			layout_strategy = "bottom_pane",
			file_ignore_patterns = {
				".git",
			},
			mappings = {
				n = {
					["q"] = require("telescope.actions").close,
					["o"] = require("telescope.actions").select_default,
					["s"] = require("telescope.actions").select_horizontal,
					["v"] = require("telescope.actions").select_vertical,
					["p"] = require("telescope.actions.layout").toggle_preview,
					["t"] = trouble.open_with_trouble,
				},
				i = {
					["<c-q>"] = require("telescope.actions").close,
					["<c-o>"] = require("telescope.actions").select_default,
					["<c-s>"] = require("telescope.actions").select_horizontal,
					["<c-v>"] = require("telescope.actions").select_vertical,
					["<c-j>"] = require("telescope.actions").move_selection_next,
					["<c-k>"] = require("telescope.actions").move_selection_previous,
					["<c-p>"] = require("telescope.actions.layout").toggle_preview,
					["<c-t>"] = trouble.open_with_trouble,
				},
			},
			layout_config = {
				bottom_pane = {
					height = 20,
					preview_cutoff = 120,
					prompt_position = "top",
				},
				current_buffer = {
					height = 0.5,
					preview_cutoff = 0,
					prompt_position = "bottom",
				},
				center = {
					height = 0.4,
					preview_cutoff = 40,
					prompt_position = "top",
					width = 0.5,
				},
				cursor = {
					height = 0.9,
					preview_cutoff = 40,
					width = 0.8,
				},
				horizontal = {
					height = 0.9,
					preview_cutoff = 120,
					prompt_position = "bottom",
					width = 0.8,
				},
				vertical = {
					height = 0.9,
					preview_cutoff = 40,
					prompt_position = "bottom",
					width = 0.8,
				},
			},
			initial_mode = "normal",
			prompt_title = false,
			border = false,
			sorting_strategy = "ascending",
			preview = {
				hide_on_startup = true,
			},
		},
		pickers = {
			find_files = {
				-- initial_mode = "insert",
				layout_strategy = "buffer_window",
				prompt_prefix = "File> ",
				prompt_title = false,
			},
			oldfiles = {
				layout_strategy = "buffer_window",
				prompt_prefix = "Old File> ",
				prompt_title = false,
			},
			live_grep = {
				layout_strategy = "buffer_window",
				initial_mode = "insert",
				prompt_prefix = "Live Grep> ",
				prompt_title = false,
			},
			current_buffer_fuzzy_find = {
				layout_strategy = "buffer_window",
				initial_mode = "insert",
				prompt_prefix = "Fuzzy Find> ",
				prompt_title = false,
			},
			registers = {
				layout_strategy = "bottom_pane",
				prompt_prefix = "Registers> ",
				prompt_title = false,
			},
			git_commit = {
				theme = "ivy",
			},
			colorscheme = {
				layout_strategy = "bottom_pane",
				prompt_prefix = "Colorscheme> ",
				prompt_title = false,
				enable_preview = true,
			},
			buffers = {
				-- theme = "ivy",
				layout_strategy = "buffer_window",
				prompt_prefix = "Buffers> ",
				prompt_title = false,
				sort_lastuseed = true,
				ignore_current_buffer = true,
        only_cwd = true,
				mappings = {
					n = {
						["d"] = "delete_buffer",
					},
				},
			},
		},
	})
	telescope.load_extension("fzf")
	telescope.load_extension("project")
end

-- fullscreen buffer picker
function Buffer_window()
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
end

return M
