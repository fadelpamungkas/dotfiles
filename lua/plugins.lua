return {
	{
		"toppair/peek.nvim",
		run = "deno task --quiet build:fast",
		ft = { "markdown" },
		opts = { app = "browser" },
	},

	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		opts = {
			ui = {
				width = 1,
				height = 1,
			},
		},
	},

	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>" } },
	},

	{
		"simrat39/rust-tools.nvim",
		-- dependencies = {
		-- 	"neovim/nvim-lspconfig",
		-- 	"nvim-lua/plenary.nvim",
		-- 	"mfussenegger/nvim-dap",
		-- },
		ft = "rust",
		config = function()
			require("rust-tools").setup({
				-- server = {
				-- 	on_attach = on_attach,
				-- },
				-- capabilities = capabilities,
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
