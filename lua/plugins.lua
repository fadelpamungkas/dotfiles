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
			features = {
				filetype = {
					on = true,
					defer = true,
				},
				illuminate = {
					on = true,
					defer = false,
				},
				indent_blankline = {
					on = true,
					defer = false,
				},
				lsp = {
					on = true,
					defer = false,
				},
				lualine = {
					on = true,
					defer = false,
				},
				matchparen = {
					on = true,
					defer = false,
				},
				syntax = {
					on = true,
					defer = true,
				},
				treesitter = {
					on = true,
					defer = false,
				},
				vimopts = {
					on = true,
					defer = false,
				},
			},
		},
	},
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
				background = {
					light = "latte",
					dark = "mocha",
				},
				color_overrides = {
					latte = {
						rosewater = "#c14a4a",
						flamingo = "#c14a4a",
						red = "#c14a4a",
						maroon = "#c14a4a",
						pink = "#945e80",
						mauve = "#945e80",
						peach = "#c35e0a",
						yellow = "#b47109",
						green = "#6c782e",
						teal = "#4c7a5d",
						sky = "#4c7a5d",
						sapphire = "#4c7a5d",
						blue = "#45707a",
						lavender = "#45707a",
						text = "#654735",
						subtext1 = "#73503c",
						subtext0 = "#805942",
						overlay2 = "#8c6249",
						overlay1 = "#8c856d",
						overlay0 = "#a69d81",
						surface2 = "#bfb695",
						surface1 = "#d1c7a3",
						surface0 = "#e3dec3",
						base = "#f9f5d7",
						mantle = "#f0ebce",
						crust = "#e8e3c8",
					},
					mocha = {
						rosewater = "#ea6962",
						flamingo = "#ea6962",
						red = "#ea6962",
						maroon = "#ea6962",
						pink = "#d3869b",
						mauve = "#d3869b",
						peach = "#e78a4e",
						yellow = "#d8a657",
						green = "#a9b665",
						teal = "#89b482",
						sky = "#89b482",
						sapphire = "#89b482",
						blue = "#7daea3",
						lavender = "#7daea3",
						text = "#ebdbb2",
						subtext1 = "#d5c4a1",
						subtext0 = "#bdae93",
						overlay2 = "#a89984",
						overlay1 = "#928374",
						overlay0 = "#595959",
						surface2 = "#4d4d4d",
						surface1 = "#404040",
						surface0 = "#292929",
						base = "#1d2021",
						mantle = "#191b1c",
						crust = "#141617",
					},
				},
				transparent_background = false,
				show_end_of_buffer = true,
				integration_default = false,
				integrations = {
					barbecue = { dim_dirname = true, bold_basename = true, dim_context = false, alt_background = false },
					cmp = true,
					gitsigns = true,
					hop = true,
					illuminate = { enabled = true },
					native_lsp = { enabled = true, inlay_hints = { background = true } },
					neogit = true,
					neotree = true,
					semantic_tokens = true,
					treesitter = true,
					treesitter_context = true,
					vimwiki = true,
					which_key = true,
				},
				highlight_overrides = {
					all = function(colors)
						return {
							CmpItemMenu = { fg = colors.surface2 },
							CursorLineNr = { fg = colors.text },
							FloatBorder = { bg = colors.base, fg = colors.surface0 },
							GitSignsChange = { fg = colors.peach },
							LineNr = { fg = colors.overlay0 },
							LspInfoBorder = { link = "FloatBorder" },
							NeoTreeDirectoryIcon = { fg = colors.subtext1 },
							NeoTreeDirectoryName = { fg = colors.subtext1 },
							NeoTreeFloatBorder = { link = "TelescopeResultsBorder" },
							NeoTreeGitConflict = { fg = colors.red },
							NeoTreeGitDeleted = { fg = colors.red },
							NeoTreeGitIgnored = { fg = colors.overlay0 },
							NeoTreeGitModified = { fg = colors.peach },
							NeoTreeGitStaged = { fg = colors.green },
							NeoTreeGitUnstaged = { fg = colors.red },
							NeoTreeGitUntracked = { fg = colors.green },
							NeoTreeIndent = { fg = colors.surface1 },
							NeoTreeNormal = { bg = colors.mantle },
							NeoTreeNormalNC = { bg = colors.mantle },
							NeoTreeRootName = { fg = colors.subtext1, style = { "bold" } },
							NeoTreeTabActive = { fg = colors.text, bg = colors.mantle },
							NeoTreeTabInactive = { fg = colors.surface2, bg = colors.crust },
							NeoTreeTabSeparatorActive = { fg = colors.mantle, bg = colors.mantle },
							NeoTreeTabSeparatorInactive = { fg = colors.crust, bg = colors.crust },
							NeoTreeWinSeparator = { fg = colors.base, bg = colors.base },
							NormalFloat = { bg = colors.base },
							Pmenu = { bg = colors.mantle, fg = "" },
							PmenuSel = { bg = colors.surface0, fg = "" },
							TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
							TelescopePreviewNormal = { bg = colors.crust },
							TelescopePreviewTitle = { fg = colors.crust, bg = colors.crust },
							TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
							TelescopePromptCounter = { fg = colors.mauve, style = { "bold" } },
							TelescopePromptNormal = { bg = colors.surface0 },
							TelescopePromptPrefix = { bg = colors.surface0 },
							TelescopePromptTitle = { fg = colors.surface0, bg = colors.surface0 },
							TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
							TelescopeResultsNormal = { bg = colors.mantle },
							TelescopeResultsTitle = { fg = colors.mantle, bg = colors.mantle },
							TelescopeSelection = { bg = colors.surface0 },
							VertSplit = { bg = colors.base, fg = colors.surface0 },
							WhichKeyFloat = { bg = colors.mantle },
							YankHighlight = { bg = colors.surface2 },
							FidgetTask = { fg = colors.subtext2 },
							FidgetTitle = { fg = colors.peach },

							IblIndent = { fg = colors.surface0 },
							IblScope = { fg = colors.overlay0 },

							Boolean = { fg = colors.mauve },
							Number = { fg = colors.mauve },
							Float = { fg = colors.mauve },

							PreProc = { fg = colors.mauve },
							PreCondit = { fg = colors.mauve },
							Include = { fg = colors.mauve },
							Define = { fg = colors.mauve },
							Conditional = { fg = colors.red },
							Repeat = { fg = colors.red },
							Keyword = { fg = colors.red },
							Typedef = { fg = colors.red },
							Exception = { fg = colors.red },
							Statement = { fg = colors.red },

							Error = { fg = colors.red },
							StorageClass = { fg = colors.peach },
							Tag = { fg = colors.peach },
							Label = { fg = colors.peach },
							Structure = { fg = colors.peach },
							Operator = { fg = colors.peach },
							Title = { fg = colors.peach },
							Special = { fg = colors.yellow },
							SpecialChar = { fg = colors.yellow },
							Type = { fg = colors.yellow, style = { "bold" } },
							Function = { fg = colors.green, style = { "bold" } },
							Delimiter = { fg = colors.subtext2 },
							Ignore = { fg = colors.subtext2 },
							Macro = { fg = colors.teal },

							TSAnnotation = { fg = colors.mauve },
							TSAttribute = { fg = colors.mauve },
							TSBoolean = { fg = colors.mauve },
							TSCharacter = { fg = colors.teal },
							TSCharacterSpecial = { link = "SpecialChar" },
							TSComment = { link = "Comment" },
							TSConditional = { fg = colors.red },
							TSConstBuiltin = { fg = colors.mauve },
							TSConstMacro = { fg = colors.mauve },
							TSConstant = { fg = colors.text },
							TSConstructor = { fg = colors.green },
							TSDebug = { link = "Debug" },
							TSDefine = { link = "Define" },
							TSEnvironment = { link = "Macro" },
							TSEnvironmentName = { link = "Type" },
							TSError = { link = "Error" },
							TSException = { fg = colors.red },
							TSField = { fg = colors.blue },
							TSFloat = { fg = colors.mauve },
							TSFuncBuiltin = { fg = colors.green },
							TSFuncMacro = { fg = colors.green },
							TSFunction = { fg = colors.green },
							TSFunctionCall = { fg = colors.green },
							TSInclude = { fg = colors.red },
							TSKeyword = { fg = colors.red },
							TSKeywordFunction = { fg = colors.red },
							TSKeywordOperator = { fg = colors.peach },
							TSKeywordReturn = { fg = colors.red },
							TSLabel = { fg = colors.peach },
							TSLiteral = { link = "String" },
							TSMath = { fg = colors.blue },
							TSMethod = { fg = colors.green },
							TSMethodCall = { fg = colors.green },
							TSNamespace = { fg = colors.yellow },
							TSNone = { fg = colors.text },
							TSNumber = { fg = colors.mauve },
							TSOperator = { fg = colors.peach },
							TSParameter = { fg = colors.text },
							TSParameterReference = { fg = colors.text },
							TSPreProc = { link = "PreProc" },
							TSProperty = { fg = colors.blue },
							TSPunctBracket = { fg = colors.text },
							TSPunctDelimiter = { link = "Delimiter" },
							TSPunctSpecial = { fg = colors.blue },
							TSRepeat = { fg = colors.red },
							TSStorageClass = { fg = colors.peach },
							TSStorageClassLifetime = { fg = colors.peach },
							TSStrike = { fg = colors.subtext2 },
							TSString = { fg = colors.teal },
							TSStringEscape = { fg = colors.green },
							TSStringRegex = { fg = colors.green },
							TSStringSpecial = { link = "SpecialChar" },
							TSSymbol = { fg = colors.text },
							TSTag = { fg = colors.peach },
							TSTagAttribute = { fg = colors.green },
							TSTagDelimiter = { fg = colors.green },
							TSText = { fg = colors.green },
							TSTextReference = { link = "Constant" },
							TSTitle = { link = "Title" },
							TSTodo = { link = "Todo" },
							TSType = { fg = colors.yellow, style = { "bold" } },
							TSTypeBuiltin = { fg = colors.yellow, style = { "bold" } },
							TSTypeDefinition = { fg = colors.yellow, style = { "bold" } },
							TSTypeQualifier = { fg = colors.peach, style = { "bold" } },
							TSURI = { fg = colors.blue },
							TSVariable = { fg = colors.text },
							TSVariableBuiltin = { fg = colors.mauve },

							["@annotation"] = { link = "TSAnnotation" },
							["@attribute"] = { link = "TSAttribute" },
							["@boolean"] = { link = "TSBoolean" },
							["@character"] = { link = "TSCharacter" },
							["@character.special"] = { link = "TSCharacterSpecial" },
							["@comment"] = { link = "TSComment" },
							["@conceal"] = { link = "Grey" },
							["@conditional"] = { link = "TSConditional" },
							["@constant"] = { link = "TSConstant" },
							["@constant.builtin"] = { link = "TSConstBuiltin" },
							["@constant.macro"] = { link = "TSConstMacro" },
							["@constructor"] = { link = "TSConstructor" },
							["@debug"] = { link = "TSDebug" },
							["@define"] = { link = "TSDefine" },
							["@error"] = { link = "TSError" },
							["@exception"] = { link = "TSException" },
							["@field"] = { link = "TSField" },
							["@float"] = { link = "TSFloat" },
							["@function"] = { link = "TSFunction" },
							["@function.builtin"] = { link = "TSFuncBuiltin" },
							["@function.call"] = { link = "TSFunctionCall" },
							["@function.macro"] = { link = "TSFuncMacro" },
							["@include"] = { link = "TSInclude" },
							["@keyword"] = { link = "TSKeyword" },
							["@keyword.function"] = { link = "TSKeywordFunction" },
							["@keyword.operator"] = { link = "TSKeywordOperator" },
							["@keyword.return"] = { link = "TSKeywordReturn" },
							["@label"] = { link = "TSLabel" },
							["@math"] = { link = "TSMath" },
							["@method"] = { link = "TSMethod" },
							["@method.call"] = { link = "TSMethodCall" },
							["@namespace"] = { link = "TSNamespace" },
							["@none"] = { link = "TSNone" },
							["@number"] = { link = "TSNumber" },
							["@operator"] = { link = "TSOperator" },
							["@parameter"] = { link = "TSParameter" },
							["@parameter.reference"] = { link = "TSParameterReference" },
							["@preproc"] = { link = "TSPreProc" },
							["@property"] = { link = "TSProperty" },
							["@punctuation.bracket"] = { link = "TSPunctBracket" },
							["@punctuation.delimiter"] = { link = "TSPunctDelimiter" },
							["@punctuation.special"] = { link = "TSPunctSpecial" },
							["@repeat"] = { link = "TSRepeat" },
							["@storageclass"] = { link = "TSStorageClass" },
							["@storageclass.lifetime"] = { link = "TSStorageClassLifetime" },
							["@strike"] = { link = "TSStrike" },
							["@string"] = { link = "TSString" },
							["@string.escape"] = { link = "TSStringEscape" },
							["@string.regex"] = { link = "TSStringRegex" },
							["@string.special"] = { link = "TSStringSpecial" },
							["@symbol"] = { link = "TSSymbol" },
							["@tag"] = { link = "TSTag" },
							["@tag.attribute"] = { link = "TSTagAttribute" },
							["@tag.delimiter"] = { link = "TSTagDelimiter" },
							["@text"] = { link = "TSText" },
							["@text.danger"] = { link = "TSDanger" },
							["@text.diff.add"] = { link = "diffAdded" },
							["@text.diff.delete"] = { link = "diffRemoved" },
							["@text.emphasis"] = { link = "TSEmphasis" },
							["@text.environment"] = { link = "TSEnvironment" },
							["@text.environment.name"] = { link = "TSEnvironmentName" },
							["@text.literal"] = { link = "TSLiteral" },
							["@text.math"] = { link = "TSMath" },
							["@text.note"] = { link = "TSNote" },
							["@text.reference"] = { link = "TSTextReference" },
							["@text.strike"] = { link = "TSStrike" },
							["@text.strong"] = { link = "TSStrong" },
							["@text.title"] = { link = "TSTitle" },
							["@text.todo"] = { link = "TSTodo" },
							["@text.todo.checked"] = { link = "Green" },
							["@text.todo.unchecked"] = { link = "Ignore" },
							["@text.underline"] = { link = "TSUnderline" },
							["@text.uri"] = { link = "TSURI" },
							["@text.warning"] = { link = "TSWarning" },
							["@todo"] = { link = "TSTodo" },
							["@type"] = { link = "TSType" },
							["@type.builtin"] = { link = "TSTypeBuiltin" },
							["@type.definition"] = { link = "TSTypeDefinition" },
							["@type.qualifier"] = { link = "TSTypeQualifier" },
							["@uri"] = { link = "TSURI" },
							["@variable"] = { link = "TSVariable" },
							["@variable.builtin"] = { link = "TSVariableBuiltin" },

							["@lsp.type.class"] = { link = "TSType" },
							["@lsp.type.comment"] = { link = "TSComment" },
							["@lsp.type.decorator"] = { link = "TSFunction" },
							["@lsp.type.enum"] = { link = "TSType" },
							["@lsp.type.enumMember"] = { link = "TSProperty" },
							["@lsp.type.events"] = { link = "TSLabel" },
							["@lsp.type.function"] = { link = "TSFunction" },
							["@lsp.type.interface"] = { link = "TSType" },
							["@lsp.type.keyword"] = { link = "TSKeyword" },
							["@lsp.type.macro"] = { link = "TSConstMacro" },
							["@lsp.type.method"] = { link = "TSMethod" },
							["@lsp.type.modifier"] = { link = "TSTypeQualifier" },
							["@lsp.type.namespace"] = { link = "TSNamespace" },
							["@lsp.type.number"] = { link = "TSNumber" },
							["@lsp.type.operator"] = { link = "TSOperator" },
							["@lsp.type.parameter"] = { link = "TSParameter" },
							["@lsp.type.property"] = { link = "TSProperty" },
							["@lsp.type.regexp"] = { link = "TSStringRegex" },
							["@lsp.type.string"] = { link = "TSString" },
							["@lsp.type.struct"] = { link = "TSType" },
							["@lsp.type.type"] = { link = "TSType" },
							["@lsp.type.typeParameter"] = { link = "TSTypeDefinition" },
							["@lsp.type.variable"] = { link = "TSVariable" },
						}
					end,
					latte = function(colors)
						return {
							IblIndent = { fg = colors.mantle },
							IblScope = { fg = colors.surface1 },

							LineNr = { fg = colors.surface1 },
						}
					end,
				},
			})

			vim.api.nvim_command("colorscheme catppuccin")
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
			{
				"mq",
				function()
					require("harpoon"):list():select(1)
				end,
			},
			{
				"mw",
				function()
					require("harpoon"):list():select(2)
				end,
			},
			{
				"me",
				function()
					require("harpoon"):list():select(3)
				end,
			},
			{
				"mr",
				function()
					require("harpoon"):list():select(4)
				end,
			},
			{
				"ma",
				function()
					require("harpoon"):list():select(5)
				end,
			},
			{
				"ms",
				function()
					require("harpoon"):list():select(6)
				end,
			},
			{
				"md",
				function()
					require("harpoon"):list():select(7)
				end,
			},
			{
				"mf",
				function()
					require("harpoon"):list():select(8)
				end,
			},
			{
				"<leader>h",
				function()
					require("harpoon"):list():add()
				end,
			},

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

	{
		"oysandvik94/curl.nvim",
		cmd = { "CurlOpen" },
		ft = { "curl" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = true,
	},
}
