local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "BufReadPost",

	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		-- "RRethy/nvim-treesitter-textsubjects",
		-- "nvim-treesitter/nvim-treesitter-refactor",
		-- "mfussenegger/nvim-treehopper",
		-- { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
	},
}

function M.config()
	local treesitter = require("nvim-treesitter.configs")
	treesitter.setup({
		-- a list of parser names, or "all"
		ensure_installed =  "all" ,
		-- ensure_installed = {
		-- 	"bash",
		-- 	"c",
		-- 	"cmake",
		-- 	-- "comment", -- comments are slowing down TS bigtime, so disable for now
		-- 	"cpp",
		-- 	"css",
		-- 	"diff",
		-- 	"fish",
		-- 	"gitignore",
		-- 	"go",
		--     "gomod",
		--     "gowork",
		-- 	"graphql",
		-- 	"help",
		-- 	"html",
		-- 	"http",
		-- 	"java",
		-- 	"javascript",
		-- 	"jsdoc",
		-- 	"jsonc",
		-- 	"latex",
		-- 	"lua",
		-- 	"markdown",
		-- 	"markdown_inline",
		-- 	"meson",
		-- 	"ninja",
		-- 	"nix",
		-- 	"norg",
		-- 	"org",
		-- 	"php",
		-- 	"python",
		-- 	"query",
		-- 	"regex",
		-- 	"rust",
		-- 	"scss",
		-- 	"sql",
		-- 	"svelte",
		-- 	"teal",
		-- 	"toml",
		-- 	"tsx",
		-- 	"typescript",
		-- 	"vhs",
		-- 	"vim",
		-- 	"vue",
		-- 	"wgsl",
		-- 	"yaml",
		-- 	"json",
		-- },

		-- 		-- install parsers synchronously (only applied to `ensure_installed`)
		sync_install = false,
		--
		-- 		-- list of parsers to ignore installing (for "all")
		ignore_install = { "phpdoc", "comment" },
		--
		highlight = {
			enable = true,
			disable = {},
			additional_vim_regex_highlighting = false,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			},
		},
		indent = {
			enable = true,
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
				keymaps = {
					-- you can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]n"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[n"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},
		},
	})
end

return M
