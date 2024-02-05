return {
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

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("ts_context_commentstring").setup({
				enable = true,
				enable_autocmd = false,
			})
		end,
	},

	{
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		opts = function()
			---@diagnostic disable-next-line: missing-fields
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
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
		cmd = { "TroubleToggle", "Trouble" },
		keys = { { "<leader>d", "<cmd>TroubleToggle document_diagnostics<cr>" } },
		opts = {
			icons = false,
			fold_open = "v",
			fold_closed = ">",
			indent_lines = false,
			use_diagnostic_signs = true,
			padding = false,
			auto_jump = { "lsp_definitions", "lsp_implementations" },
		},
	},

	{
		-- dir = "~/LuaProjects/harpoon",
		"ThePrimeagen/harpoon",
		event = "VeryLazy",
        -- stylua: ignore
		config = function()
			vim.keymap.set("n", "<leader>h", require("harpoon.mark").add_file)
			vim.keymap.set("n", "<leader>H", require("harpoon.ui").toggle_quick_menu)
			vim.keymap.set("n", "mq", function() require("harpoon.ui").nav_file(1) end)
			vim.keymap.set("n", "mw", function() require("harpoon.ui").nav_file(2) end)
			vim.keymap.set("n", "me", function() require("harpoon.ui").nav_file(3) end)
            vim.keymap.set("n", "mr", function() require("harpoon.ui").nav_file(4) end)
			vim.keymap.set("n", "ma", function() require("harpoon.ui").nav_file(5) end)
			vim.keymap.set("n", "ms", function() require("harpoon.ui").nav_file(6) end)
			vim.keymap.set("n", "md", function() require("harpoon.ui").nav_file(7) end)
            vim.keymap.set("n", "mf", function() require("harpoon.ui").nav_file(8) end)
		end,
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
