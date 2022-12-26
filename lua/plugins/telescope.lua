local M = {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
    {"nvim-lua/plenary.nvim"},
    { "nvim-telescope/telescope-file-browser.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
}

function M.init()
	vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files find_command=rg,--ignore,--files<CR>")
	vim.keymap.set("n", "<leader>e", "<cmd>Telescope file_browser<CR>")
	vim.keymap.set("n", "<leader>F", "<cmd>Telescope oldfiles<CR>")
	vim.keymap.set("n", "<leader>s", "<cmd>Telescope current_buffer_fuzzy_find<CR>")
	vim.keymap.set("n", "<leader>S", "<cmd>Telescope live_grep<CR>")
	vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>")
	vim.keymap.set("n", "<leader>r", "<cmd>Telescope registers<CR>")
	vim.keymap.set("n", "<leader>c", "<cmd>Telescope command_history<CR>")
end

function M.config()
	local telescope = require("telescope")
	local trouble = require("trouble.providers.telescope")

	telescope.setup({
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
			borderchars = { "─", "", "", "", "", "", "", "" },
			sorting_strategy = "ascending",
			preview = {
				hide_on_startup = true,
			},
		},
		pickers = {
			find_files = {
				layout_strategy = "bottom_pane",
				prompt_prefix = "Files> ",
				prompt_title = false,
			},
			oldfiles = {
				layout_strategy = "bottom_pane",
				prompt_prefix = "Old Files> ",
				prompt_title = false,
			},
			live_grep = {
				initial_mode = "insert",
				prompt_prefix = "Live Grep> ",
				prompt_title = false,
			},
			current_buffer_fuzzy_find = {
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
				layout_strategy = "bottom_pane",
				prompt_prefix = "Buffers> ",
				prompt_title = false,
				sort_lastuseed = true,
				mappings = {
					n = {
						["d"] = "delete_buffer",
					},
				},
			},
		},
		extensions = {
			-- ...
		},
	})
	telescope.load_extension("fzf")
  telescope.load_extension("file_browser")
end

return M
