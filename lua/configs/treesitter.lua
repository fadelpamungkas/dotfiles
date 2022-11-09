local present, treesitter = pcall(require, "nvim-treesitter.configs")
if not present then
	return
end

treesitter.setup({
	-- a list of parser names, or "all"
	-- ensure_installed = { "go", "gomod", "gowork", "lua", "javascript", "json", "yaml", "toml" },
	ensure_installed = "all",

	-- install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- list of parsers to ignore installing (for "all")
	ignore_install = { "phpdoc" },

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- note: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		disable = {},

		-- setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- using this option may slow down your editor, and you may see some duplicate highlights.
		-- instead of true it can also be a list of languages
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
