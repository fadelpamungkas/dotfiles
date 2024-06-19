return {
	-- {
	--        "EdenEast/nightfox.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd.colorscheme("nightfox")
	-- 	end,
	--    },
	{
		"Mofiqul/adwaita.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.adwaita_darker = true -- for darker version
			vim.g.adwaita_disable_cursorline = true -- to disable cursorline
			vim.g.adwaita_transparent = true -- makes the background transparent
			-- vim.cmd.colorscheme("adwaita")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				-- no_italic = false,
				no_bold = true,
				no_underline = true,
				transparent_background = true,
				show_end_of_buffer = true,
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	-- {
	-- 	"sainnhe/sonokai",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.g.sonokai_enable_italic = false
	-- 		-- vim.cmd.colorscheme("sonokai")
	-- 	end,
	-- },
	--
	-- {
	-- 	"rktjmp/lush.nvim",
	-- 	priority = 1000,
	-- 	lazy = false,
	-- },

	{ "nvim-lua/plenary.nvim" },

	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
	},

	-- {
	-- 	"windwp/nvim-autopairs",
	-- 	event = "InsertEnter",
	-- 	opts = {
	-- 		fast_wrap = {},
	-- 	},
	-- },

	-- {
	-- 	"altermo/ultimate-autopair.nvim",
	-- 	event = { "InsertEnter", "CmdlineEnter" },
	-- 	branch = "v0.6",
	-- 	opts = {
	-- 		--Config goes here
	-- 	},
	-- },

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

	-- {
	-- 	"JoosepAlviste/nvim-ts-context-commentstring",
	-- 	config = function()
	-- 		---@diagnostic disable-next-line: missing-fields
	-- 		require("ts_context_commentstring").setup({
	-- 			enable = true,
	-- 			enable_autocmd = false,
	-- 		})
	-- 	end,
	-- },
	--
	-- {
	-- 	"numToStr/Comment.nvim",
	-- 	event = "BufReadPost",
	-- 	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	-- 	opts = function()
	-- 		---@diagnostic disable-next-line: missing-fields
	-- 		require("Comment").setup({
	-- 			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	-- 		})
	-- 	end,
	-- },

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

	-- {
	-- 	-- dir = "~/LuaProjects/harpoon",
	-- 	"ThePrimeagen/harpoon",
	-- 	event = "VeryLazy",
	--        -- stylua: ignore
	-- 	config = function()
	-- 		vim.keymap.set("n", "<leader>h", require("harpoon.mark").add_file)
	-- 		vim.keymap.set("n", "<leader>H", require("harpoon.ui").toggle_quick_menu)
	-- 		vim.keymap.set("n", "mq", function() require("harpoon.ui").nav_file(1) end)
	-- 		vim.keymap.set("n", "mw", function() require("harpoon.ui").nav_file(2) end)
	-- 		vim.keymap.set("n", "me", function() require("harpoon.ui").nav_file(3) end)
	--            vim.keymap.set("n", "mr", function() require("harpoon.ui").nav_file(4) end)
	-- 		vim.keymap.set("n", "ma", function() require("harpoon.ui").nav_file(5) end)
	-- 		vim.keymap.set("n", "ms", function() require("harpoon.ui").nav_file(6) end)
	-- 		vim.keymap.set("n", "md", function() require("harpoon.ui").nav_file(7) end)
	--            vim.keymap.set("n", "mf", function() require("harpoon.ui").nav_file(8) end)
	-- 	end,
	-- },

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		event = "VeryLazy",
		opts = {
			settings = {
				save_on_toggle = true,
			},
		},
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
						-- title_pos = "center",
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

	-- {
	-- 	"folke/persistence.nvim",
	-- 	event = "BufReadPre",
	-- 	opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
	-- 	keys = {
	-- 		{ "<leader>z", [[<cmd>lua require("persistence").load()<cr>]] },
	-- 		{ "<leader>Z", [[<cmd>lua require("persistence").load({ last = true })<cr>]] },
	-- 	},
	-- },

	{
		"rest-nvim/rest.nvim",
		dependencies = { { "nvim-lua/plenary.nvim" } },
		keys = {
			{ "<leader>cr", "<Plug>RestNvim" },
			{ "<leader>cp", "<Plug>RestNvimPreview" },
			{ "<leader>cl", "<Plug>RestNvimLast" },
		},
		commit = "8b62563",
		ft = { "http" },
		opts = {
			result_split_horizontal = true,
		},
	},
}
