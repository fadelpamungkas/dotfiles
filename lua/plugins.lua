return {
	{
		"toppair/peek.nvim",
		run = "deno task --quiet build:fast",
		ft = { "markdown" },
		opts = { app = "browser" },
	},

	{
		"simrat39/rust-tools.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
		},
		config = true,
		ft = "rust",
	},

	{
		"akinsho/flutter-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		ft = "dart",
	},

	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		keys = {
			{
				"gR",
				-- ":IncRename ",
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
		"kylechui/nvim-surround",
		event = "BufReadPre",
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
		"ggandor/leap.nvim",
		keys = {
			{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
			{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
			{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
			leap.add_default_mappings(true)
			vim.keymap.del({ "x", "o" }, "x")
			vim.keymap.del({ "x", "o" }, "X")
		end,
	},

	{
		"ggandor/flit.nvim",
		keys = function()
			local ret = {}
			for _, key in ipairs({ "f", "F", "t", "T" }) do
				ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
			end
			return ret
		end,
		opts = { labeled_modes = "nx" },
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

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = true,
					auto_refresh = false,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<C-CR>",
					},
					layout = {
						position = "bottom", -- | top | left | right
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<C-;>",
						accept_word = false,
						accept_line = false,
						next = "<C-]>",
						prev = "<C-[>",
						dismiss = "<C-\\>",
					},
				},
				filetypes = {
					-- yaml = false,
					-- markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
				copilot_node_command = "node", -- Node.js version must be > 16.x
				server_opts_overrides = {},
			})
		end,
	},

	{
		"nvim-neorg/neorg",
		ft = "norg",
		build = ":Neorg sync-parsers",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			load = {
				["core.defaults"] = {},
				["core.norg.concealer"] = {},
				["core.norg.completion"] = {
					config = { engine = "nvim-cmp" },
				},
				["core.integrations.nvim-cmp"] = {},

				["core.norg.dirman"] = { -- Manages Neorg workspaces
					config = {
						workspaces = {
							notes = "~/notes",
						},
					},
				},
			},
		},
	},

	-- {
	-- 	"james1236/backseat.nvim",
	-- 	--    cmd = "Backseat",
	-- 	config = function()
	-- 		require("backseat").setup({
	-- 			-- Alternatively, set the env var $OPENAI_API_KEY by putting "export OPENAI_API_KEY=sk-xxxxx" in your ~/.bashrc
	-- 			-- openai_api_key = "sk-xxxxxxxxxxxxxx", -- Get yours from platform.openai.com/account/api-keys
	-- 			-- openai_model_id = "gpt-3.5-turbo", --gpt-4 (If you do not have access to a model, it says "The model does not exist")
	--
	-- 			split_threshold = 100,
	-- 			-- additional_instruction = "Respond snarkily", -- (GPT-3 will probably deny this request, but GPT-4 complies)
	-- 			-- highlight = {
	-- 			--     icon = '', -- ''
	-- 			--     group = 'Comment',
	-- 			-- }
	-- 		})
	-- },
	-- {
	-- 	"dstein64/vim-startuptime",
	-- 	cmd = "StartupTime",
	-- 	config = function()
	-- 		vim.g.startuptime_tries = 10
	-- 	end,
	-- },
	-- {
	-- 	"ThePrimeagen/refactoring.nvim",
	-- 	keys = {
	-- 		{
	-- 			"<leader>r",
	-- 			function()
	-- 				require("refactoring").select_refactor()
	-- 			end,
	-- 			mode = "v",
	-- 			noremap = true,
	-- 			silent = true,
	-- 			expr = false,
	-- 		},
	-- 	},
	-- 	opts = {},
	-- },
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
