return {
	{
		"toppair/peek.nvim",
		run = "deno task --quiet build:fast",
		ft = { "markdown" },
		opts = { app = "browser" },
	},

	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>" } },
	},

	{
		"simrat39/rust-tools.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
		},
		ft = "rust",
	},

	-- {
	-- 	"akinsho/flutter-tools.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- 	ft = "dart",
	-- },

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
				mode = { "n", "x", "o" },
				desc = "Rename",
				expr = true,
			},
		},
		config = true,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},

	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = true,
	},

	{
		"kylechui/nvim-surround",
		event = "BufReadPre",
		config = true,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = true,
	},

	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		opts = { use_icons = false },
	},
}
