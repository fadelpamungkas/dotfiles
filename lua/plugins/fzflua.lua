return {
	"ibhagwan/fzf-lua",
	cmd = "FzfLua",
	-- enabled = false,
	-- keys = {
	-- 	{ "<leader>f", "<cmd>FzfLua files<CR>" },
	-- 	{ "<leader>F", "<cmd>FzfLua oldfiles<CR>" },
	-- 	{ "<leader>/", "<cmd>FzfLua grep_curbuf<CR>" },
	-- 	{ "<leader>S", "<cmd>FzfLua live_grep<CR>" },
	-- 	{ "<leader>b", "<cmd>FzfLua buffers<CR>" },
	-- 	{ "<leader>o", "<cmd>FzfLua lsp_document_symbols<CR>" },
	-- 	{ "<leader>;", "<cmd>FzfLua resume<CR>" },
	-- },
	config = function()
		local actions = require("fzf-lua.actions")
		require("fzf-lua").setup({
			"max-perf",
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
			keymap = {
				fzf = {
					["ctrl-q"] = "select+toggle-all+accept",
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
