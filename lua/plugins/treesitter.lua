return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		{
			"andymass/vim-matchup",
			config = function()
				vim.cmd([[hi MatchWord guibg=NONE]])
			end,
		},
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
		{ "nvim-treesitter/nvim-treesitter-context", config = true },
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = "all",
			sync_install = false,
			ignore_install = { "phpdoc", "comment" },
			context_commentstring = { enable = true, enable_autocmd = false },
			highlight = {
				enable = true,
				disable = {},
				additional_vim_regex_highlighting = false,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<c-n>",
					node_incremental = "<c-n>",
					scope_incremental = "<c-m>",
					node_decremental = "<c-p>",
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
						["aP"] = "@parameter.outer",
						["iP"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aB"] = "@block.outer",
						["iB"] = "@block.inner",
					},
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
					},
					include_surrounding_whitespace = true,
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
			matchup = {
				enable = true,
				disable_virtual_text = true,
			},
		})
	end,
}
