return {
	-- { "lewis6991/impatient.nvim", lazy = false, enable = true },
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		config = function()
			vim.cmd.colorscheme("oxocarbon")
		end,
	},

	{
		"williamboman/mason.nvim",
		config = true,
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
		dependencies = {
			"ggandor/flit.nvim",
			config = function()
				require("flit").setup({
					keys = { f = "f", F = "F", t = "t", T = "T" },
					-- A string like "nv", "nvo", "o", etc.
					labeled_modes = "nv",
					multiline = true,
					-- Like `leap`s similar argument (call-specific overrides).
					-- E.g.: opts = { equivalence_classes = {} }
					opts = {},
				})
			end,
		},
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
		opts = { use_icons = false },
	},

	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
		keys = {
			{
				"<leader>rs",
				function()
					require("persistence").load()
				end,
				desc = "Restore Session",
			},
			{
				"<leader>rl",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore Last Session",
			},
			{
				"<leader>rd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't Save Current Session",
			},
		},
	},

	-- {
	-- 	"folke/zen-mode.nvim",
	-- 	cmd = { "ZenMode" },
	-- 	config = function()
	-- 		require("zen-mode").setup({})
	-- 	end,
	-- },
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
