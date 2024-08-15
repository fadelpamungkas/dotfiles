return {
	{
		"pteroctopus/faster.nvim",
		cmd = "FasterDisableAllFeatures",
		opts = {
			behaviours = {
				bigfile = {
					on = true,
					features_disabled = {
						"matchparen",
						"lsp",
						"treesitter",
						"syntax",
						"filetype",
					},
					filesize = 5,
					pattern = "*",
					extra_patterns = {
						{ filesize = 0.5, pattern = "*.json" },
					},
				},
				fastmacro = {
					on = true,
					features_disabled = { "lualine" },
				},
			},
			-- Feature table contains configuration for features faster.nvim will disable
			-- and enable according to rules defined in behaviours.
			-- Defined feature will be used by faster.nvim only if it is on (`on=true`).
			-- Defer will be used if some features need to be disabled after others.
			-- defer=false features will be disabled first and defer=true features last.
      -- stylua: ignore
			features = {
				filetype = { on = true, defer = true },
				illuminate = { on = true, defer = false },
				indent_blankline = { on = true, defer = false },
				lsp = { on = true, defer = false },
				lualine = { on = true, defer = false },
				matchparen = { on = true, defer = false },
				syntax = { on = true, defer = true },
				treesitter = { on = true, defer = false },
				vimopts = { on = true, defer = false },
			},
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				show_end_of_buffer = true,
				integration_default = false,
				integrations = {
					cmp = true,
					gitsigns = true,
					illuminate = { enabled = true },
					native_lsp = { enabled = true, inlay_hints = { background = true } },
					neogit = true,
					semantic_tokens = true,
					treesitter = true,
					treesitter_context = true,
					which_key = true,
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{ "nvim-lua/plenary.nvim" },

	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
	},

	{
		"kylechui/nvim-surround",
		version = "*",
		event = "BufReadPost",
		opts = {},
	},

	{
		"Wansmer/treesj",
		keys = { { "gJ", "<cmd>TSJToggle<cr>" } },
		opts = { use_default_keymaps = false },
	},

	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = { ui = { width = 1, height = 1 } },
	},

	{
		"windwp/nvim-spectre",
		cmd = { "Spectre" },
		keys = {
			{ "<leader>r", '<esc><cmd>lua require("spectre").open_file_search()<CR>', mode = "v" },
			{ "<leader>r", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', mode = "n" },
		},
	},

	{
		"folke/trouble.nvim",
		cmd = { "Trouble" },
		keys = { { "<leader>d", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" } },
		opts = {
			icons = {
				indent = {
					top = "| ",
					middle = "+-",
					last = "`-",
					fold_open = "> ",
					fold_closed = "v ",
					ws = "  ",
				},
				folder_closed = "[ ] ",
				folder_open = "[>] ",
			},
			focus = true,
			fold_open = "v",
			fold_closed = ">",
			indent_lines = false,
			use_diagnostic_signs = true,
			padding = false,
			auto_jump = { "lsp_definitions", "lsp_implementations" },
		},
	},

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		event = "VeryLazy",
		opts = {
			settings = {
				save_on_toggle = true,
			},
		},
    -- stylua: ignore
		keys = {
			{ "mq", function() require("harpoon"):list():select(1) end },
			{ "mw", function() require("harpoon"):list():select(2) end },
			{ "me", function() require("harpoon"):list():select(3) end },
			{ "mr", function() require("harpoon"):list():select(4) end },
			{ "ma", function() require("harpoon"):list():select(5) end },
			{ "ms", function() require("harpoon"):list():select(6) end },
			{ "md", function() require("harpoon"):list():select(7) end },
			{ "mf", function() require("harpoon"):list():select(8) end },
			{ "<leader>h", function() require("harpoon"):list():add() end },
			{
				"<leader>H",
				function()
					local harpoon = require("harpoon")
					local opts = {
						border = "rounded",
						title = " Navigator ",
						ui_width_ratio = 0.35,
					}

					harpoon.ui:toggle_quick_menu(harpoon:list(), opts)
				end,
			},
		},
	},

	{
		"stevearc/oil.nvim",
		lazy = false,
		keys = { { "-", "<cmd>lua require('oil').open()<CR>" } },
		opts = {
			default_file_explorer = true,
			use_default_keymaps = false,
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-o>"] = "actions.select",
				["<C-v>"] = "actions.select_vsplit",
				["<C-x>"] = "actions.select_split",
				["<C-t>"] = "actions.select_tab",
				["<C-p>"] = "actions.preview",
				["q"] = "actions.close",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["zr"] = "actions.refresh",
				["zh"] = "actions.toggle_hidden",
			},
		},
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
    -- stylua: ignore
		keys = {
			{ "s", function() require("flash").jump() end, mode = { "n", "x", "o" } },
			{ "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" } },
		},
		opts = {
			-- jump = { autojump = true },
			modes = { char = { jump_labels = true, multi_line = false } },
		},
	},

	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
		keys = {
			{ "<leader>z", [[<cmd>lua require("persistence").load()<cr>]] },
			{ "<leader>Z", [[<cmd>lua require("persistence").load({ last = true })<cr>]] },
		},
	},

	{
		"oysandvik94/curl.nvim",
		cmd = { "CurlOpen" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
	},
}
