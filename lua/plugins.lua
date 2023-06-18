return {
	{ "nvim-lua/plenary.nvim" },
	{ "mbbill/undotree", cmd = "UndotreeToggle" },
	{ "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
	{ "windwp/nvim-ts-autotag", event = "InsertEnter", opts = {} },
	{ "kylechui/nvim-surround", version = "*", event = "BufReadPost", opts = {} },
	{ "NvChad/nvim-colorizer.lua", cmd = "ColorizerToggle", opts = { user_default_options = { tailwind = true } } },
	{ "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline", opts = {} },
	{ "Wansmer/treesj", keys = { { "gK", "<cmd>TSJToggle<cr>" } }, opts = { use_default_keymaps = false } },
	{ "toppair/peek.nvim", build = "deno task --quiet build:fast", ft = { "markdown" } },
	{ "williamboman/mason.nvim", cmd = "Mason", build = ":MasonUpdate", opts = { ui = { width = 1, height = 1 } } },

	{
		"jackMort/ChatGPT.nvim",
    cmd = "ChatGPT",
		opts = {},
		dependencies = { "MunifTanjim/nui.nvim" },
	},

	{
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		opts = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},

	{
		"simrat39/rust-tools.nvim",
		ft = "rust",
		config = function()
			require("rust-tools").setup({
				tools = {
					inlay_hints = {
						auto = true,
						only_current_line = false,
						show_parameter_hints = true,
						parameter_hints_prefix = "<- ",
						other_hints_prefix = "",
						max_len_align = false,
						max_len_align_padding = 1,
						right_align = false,
						right_align_padding = 7,
						highlight = "Comment",
					},
				},
			})
		end,
	},

	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		keys = {
			{
				"gR",
				function()
					require("inc_rename")
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				expr = true,
			},
		},
		config = true,
	},

	{
		"windwp/nvim-spectre",
		cmd = { "Spectre" },
		keys = {
			{ "<leader>rp", '<cmd>lua require("spectre").open()<CR>', mode = "n" },
			{ "<leader>rw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', mode = "n" },
			{ "<leader>rw", '<esc><cmd>lua require("spectre").open_visual()<CR>', mode = "v" },
			{ "<leader>rf", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', mode = "n" },
		},
	},

	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
		keys = {
			{ "<leader>z", [[<cmd>lua require("persistence").load()<cr>]] },
			{ "<leader>Z", [[<cmd>lua require("persistence").load({ last = true })<cr>]] },
		},
	},

	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		keys = { { "<leader>d", "<cmd>TroubleToggle document_diagnostics<cr>" } },
		opts = {
			icons = false,
			fold_open = "v",
			fold_closed = ">",
			indent_lines = false,
			use_diagnostic_signs = true,
			padding = false,
			action_keys = {
				close_folds = { "c", "zm" },
				open_folds = { "e", "zr" },
				toggle_fold = { "f", "za" },
			},
		},
	},

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			panel = { keymap = { open = "<C-CR>" } },
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<C-s>",
					next = "<C-]>",
					prev = "<C-[>",
					dismiss = "<C-\\>",
				},
			},
			filetypes = {
				yaml = true,
				markdown = true,
			},
		},
	},

	{
		"akinsho/toggleterm.nvim",
		cmd = "ToggleTerm",
		keys = { { "<C-t>" }, { "<C-\\>", "<cmd>ToggleTerm direction=horizontal<CR>" } },
		opts = { open_mapping = [[<c-t>]], direction = "tab" },
	},

	{
		"ThePrimeagen/harpoon",
		event = "VeryLazy",
		config = function()
			vim.keymap.set("n", "<leader>h", require("harpoon.mark").add_file)
			vim.keymap.set("n", "<leader>H", require("harpoon.ui").toggle_quick_menu)

			vim.keymap.set("n", "<c-1>", function()
				require("harpoon.ui").nav_file(1)
			end)
			vim.keymap.set("n", "<c-2>", function()
				require("harpoon.ui").nav_file(2)
			end)
			vim.keymap.set("n", "<c-3>", function()
				require("harpoon.ui").nav_file(3)
			end)
			vim.keymap.set("n", "<c-0>", function()
				require("harpoon.ui").nav_file(4)
			end)
			vim.keymap.set("n", "<c-9>", function()
				require("harpoon.ui").nav_file(5)
			end)
			vim.keymap.set("n", "<c-8>", function()
				require("harpoon.ui").nav_file(6)
			end)
		end,
	},

	{
		"ggandor/leap.nvim",
		keys = {
			{
				"s",
				function()
					require("leap").leap({
						target_windows = vim.tbl_filter(function(win)
							return vim.api.nvim_win_get_config(win).focusable
						end, vim.api.nvim_tabpage_list_wins(0)),
					})
				end,
				mode = { "n", "x", "o" },
			},
		},
		opts = {},
	},

	{
		"ggandor/flit.nvim",
		keys = {
			{ "f", mode = { "n", "x", "o" } },
			{ "F", mode = { "n", "x", "o" } },
			{ "t", mode = { "n", "x", "o" } },
			{ "T", mode = { "n", "x", "o" } },
		},
		opts = { labeled_modes = "nxo" },
	},

	{
		"stevearc/oil.nvim",
		lazy = false,
		keys = { { "-", "<cmd>lua require('oil').open()<CR>" } },
		opts = {
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
}
