return {
	-- { "lewis6991/impatient.nvim", lazy = false, enable = true },
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		config = function()
			vim.cmd([[colorscheme oxocarbon]])
		end,
	},

	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
	},

	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		config = function()
			vim.g.startuptime_tries = 10
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre",
		config = function()
			require("treesitter-context").setup()
		end,
	},

	{
		"kylechui/nvim-surround",
		event = "BufReadPre",
		config = function()
			require("nvim-surround").setup()
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	{
		"ggandor/leap.nvim",
		event = "BufReadPre",
		config = function()
			require("leap").add_default_mappings()
			vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("gitsigns").setup()
		end,
	},

	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },

		config = function()
			require("diffview").setup({})
		end,
	},
	-- use({
	-- 	"nagy135/typebreak.nvim",
	-- 	requires = "nvim-lua/plenary.nvim",
	-- 	module = "typebreak",
	-- })
	-- use({
	-- 	"tamton-aquib/duck.nvim",
	-- 	config = function()
	-- 		vim.keymap.set("n", "<leader>dj", function()
	-- 			require("duck").hatch()
	-- 		end, {})
	-- 		vim.keymap.set("n", "<leader>dk", function()
	-- 			require("duck").cook()
	-- 		end, {})
	-- 	end,
	-- })
}
