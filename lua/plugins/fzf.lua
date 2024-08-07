return {
	"ibhagwan/fzf-lua",
	cmd = "FzfLua",
	keys = {
		{ "<leader>f", "<cmd>lua require'fzf-lua'.files()<CR>" },
		{ "<leader>F", "<cmd>lua require'fzf-lua'.oldfiles()<CR>" },
		{ "<leader>/", "<cmd>lua require'fzf-lua'.grep_curbuf()<CR>" },
		{ "<leader>S", "<cmd>lua require'fzf-lua'.live_grep()<CR>" },
		{ "<leader>b", "<cmd>lua require'fzf-lua'.buffers()<CR>" },
		{ "<leader>o", "<cmd>lua require'fzf-lua'.lsp_document_symbols()<CR>" },
		{ "<leader>,", "<cmd>lua require'fzf-lua'.resume()<CR>" },
		{
			"<leader>t",
			"<cmd>lua require'fzf-lua'.grep({ search='(TODO:|FIXME:|FIX:|ISSUE:|NOTE:|INFO:|WARN:|PERF:|TEST:)', no_esc=true })<CR>",
		},
	},
	config = function()
		local actions = require("fzf-lua.actions")
		require("fzf-lua").setup({
			winopts = {
				-- split = "belowright new", -- open in a top split
				-- border = "none",
				-- fullscreen = true,
				preview = {
					-- default = "builtin",
					border = "noborder",
					delay = 0,
					scrollbar = false,
				},
			},
			files = {
				fd_opts = [[--color=never --type f --hidden --follow --exclude '.git' --exclude 'node_modules' --exclude '.npm']],
			},
			grep = {
				rg_opts = "--column --follow --line-number --no-heading "
					.. "--color=always --smart-case -g '!{node_modules,.git,**/_build,deps,.elixir_ls,**/target,**/assets/node_modules,**/assets/vendor,**/.next,**/.vercel,**/build,**/out}'",
			},
			keymap = {
				fzf = {
					["ctrl-q"] = "select-all+accept",
				},
			},
			actions = {
				files = {
					["default"] = actions.file_edit_or_qf,
					["ctrl-x"] = actions.file_split,
					["ctrl-v"] = actions.file_vsplit,
					["ctrl-t"] = actions.file_tabedit,
					["ctrl-s"] = function(selected, _)
						pcall(require("harpoon.mark").add_file, selected[1])
					end,
				},
			},
		})
	end,
}
