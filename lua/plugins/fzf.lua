return {
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		-- enabled = false,
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
	},

	-- {
	-- 	"nvim-telescope/telescope.nvim",
	-- 	cmd = "Telescope",
	-- 	-- enabled = false,
	-- 	-- keys = {
	-- 	-- 	{ "<leader>f", "<cmd>Telescope find_files hidden=true<CR>" },
	-- 	-- 	{ "<leader>F", "<cmd>Telescope oldfiles<CR>" },
	-- 	-- 	{ "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>" },
	-- 	-- 	{ "<leader>S", "<cmd>Telescope live_grep<CR>" },
	-- 	-- 	{ "<leader>b", "<cmd>Telescope buffers<CR>" },
	-- 	-- 	{ "<leader>o", "<cmd>Telescope lsp_document_symbols<CR>" },
	-- 	-- 	{ "<leader>,", "<cmd>Telescope resume<CR>" },
	--  --           { "<leader>t", "<cmd>Telescope live_grep default_text=(TODO:|FIXME:|FIX:|ISSUE:|NOTE:|INFO:|WARN:|PERF:|TEST:)<CR>" },
	-- 	-- },
	-- 	dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
	-- 	config = function()
	-- 		require("telescope").setup({
	-- 			defaults = {
	-- 				winblend = 0,
	-- 				prompt_title = "",
	-- 				preview_title = "",
	-- 				selection_caret = "",
	-- 				entry_prefix = "",
	-- 				multi_icon = "",
	-- 				color_devicons = false,
	-- 				-- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
	-- 				-- preview = { msg_bg_fillchar = " " },
	-- 				layout_config = {
	-- 					prompt_position = "top",
	-- 					preview_width = 0.5,
	-- 					-- anchor = "N",
	-- 					-- width = 0.8,
	-- 					-- height = 0.8,
	-- 					-- preview_cutoff = 120,
	-- 				},
	-- 				sorting_strategy = "ascending",
	-- 				layout_strategy = "horizontal",
	-- 				results_title = "",
	-- 				file_ignore_patterns = { "node_modules", ".pyc", ".git" },
	-- 				prompt_prefix = ":",
	-- 				mappings = {
	-- 					n = {
	-- 						["o"] = require("telescope.actions").select_default,
	-- 						["q"] = require("telescope.actions").close,
	-- 						["p"] = require("telescope.actions.layout").toggle_preview,
	-- 						["t"] = require("trouble.providers.telescope").open_with_trouble,
	-- 						["h"] = function(tb)
	-- 							require("telescope.actions").drop_all(tb)
	-- 							require("telescope.actions").add_selection(tb)
	-- 							require("telescope.actions.utils").map_selections(tb, function(selection)
	-- 								pcall(require("harpoon.mark").add_file, selection[1])
	-- 							end)
	-- 							require("telescope.actions").remove_selection(tb)
	-- 						end,
	-- 					},
	-- 				},
	-- 			},
	-- 		})
	-- 		require("telescope").load_extension("fzf")
	-- 	end,
	-- },
}
