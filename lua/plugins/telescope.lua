local M = {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		-- { "nvim-telescope/telescope-file-browser.nvim" },
		{ "nvim-telescope/telescope-project.nvim" },
		-- { "gnikdroy/projections.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
}

function M.init()
	vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files find_command=rg,--ignore,--files<CR>")
	-- vim.keymap.set("n", "<leader>e", "<cmd>Telescope file_browser<CR>")
	vim.keymap.set("n", "<leader>F", "<cmd>Telescope oldfiles<CR>")
	vim.keymap.set("n", "<leader>s", "<cmd>Telescope current_buffer_fuzzy_find<CR>")
	vim.keymap.set("n", "<leader>S", "<cmd>Telescope live_grep<CR>")
	vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>")
	vim.keymap.set("n", "<leader>R", "<cmd>Telescope registers<CR>")
	vim.keymap.set("n", "<leader>c", "<cmd>Telescope command_history<CR>")
	vim.keymap.set("n", "<leader>m", function()
		require("telescope").extensions.project.project({})
	end, { desc = "Find Project" })
	-- vim.keymap.set("n", "<leader>M", function()
	-- 	vim.cmd("Telescope projections")
	-- end)
end

function M.config()
	local telescope = require("telescope")
	local trouble = require("trouble.providers.telescope")

	-- fullscreen buffer picker
	require("telescope.pickers.layout_strategies").buffer_window = function(self)
		local layout = require("telescope.pickers.window").get_initial_window_options(self)
		local prompt = layout.prompt
		local results = layout.results
		local preview = layout.preview
		-- local config = self.layout_config
		local padding = self.window.border and 2 or 0
		local width = vim.api.nvim_win_get_width(self.original_win_id)
		local height = vim.api.nvim_win_get_height(self.original_win_id)
		local pos = vim.api.nvim_win_get_position(self.original_win_id)
		-- local wline = pos[1] + 1
		local wcol = pos[2] + 1

		-- Height
		prompt.height = 2
		preview.height = self.previewer and math.floor(height * 0.4) or 0
		results.height = height
			- padding
			- (prompt.height + padding)
			- (self.previewer and (preview.height + padding) or 0)

		-- Line
		local rows = {}
		-- local mirror = config.mirror == true
		-- local top_prompt = config.prompt_position == "top"
		-- if mirror and top_prompt then
		rows = { prompt, results, preview }
		-- elseif mirror and not top_prompt then
		-- 	rows = { results, prompt, preview }
		-- elseif not mirror and top_prompt then
		-- 	rows = { preview, prompt, results }
		-- elseif not mirror and not top_prompt then
		-- 	rows = { preview, results, prompt }
		-- end
		local next_line = 1 + padding / 2
		for _, v in pairs(rows) do
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

	-- require("projections").setup({})
	telescope.setup({
		extensions = {
			-- fzf = {
			--   fuzzy = true, -- false will only do exact matching
			--   override_generic_sorter = true, -- override the generic sorter
			--   override_file_sorter = true, -- override the file sorter
			--   case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			--   -- the default case_mode is "smart_case"
			-- },
		},
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
			borderchars = { "─", "", "", "", "", "", "", "" },
			sorting_strategy = "ascending",
			preview = {
				hide_on_startup = true,
			},
		},
		pickers = {
			find_files = {
				-- initial_mode = "insert",
				layout_strategy = "buffer_window",
				prompt_prefix = "Files> ",
				prompt_title = false,
			},
			oldfiles = {
				layout_strategy = "buffer_window",
				prompt_prefix = "Old Files> ",
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
	-- telescope.load_extension("file_browser")
	-- telescope.load_extension("projections")
	--
	-- -- Autostore session on VimExit
	-- local Session = require("projections.session")
	-- vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
	-- 	callback = function()
	-- 		Session.store(vim.loop.cwd())
	-- 	end,
	-- })
	--
	-- -- Switch to project if vim was started in a project dir
	-- local switcher = require("projections.switcher")
	-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
	-- 	callback = function()
	-- 		if vim.fn.argc() == 0 then
	-- 			switcher.switch(vim.loop.cwd())
	-- 		end
	-- 	end,
	-- })
end

return M
