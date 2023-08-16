return {
	"ibhagwan/fzf-lua",
	cmd = "FzfLua",
	-- enabled = false,
	-- keys = {
	-- 	{ "<leader>f", "<cmd>FzfLua files<CR>" },
	-- 	{ "<leader>F", "<cmd>FzfLua oldfiles<CR>" },
	-- 	{ "<leader>s", "<cmd>FzfLua grep_curbuf<CR>" },
	-- 	{ "<leader>S", "<cmd>FzfLua live_grep<CR>" },
	-- 	{ "<leader>b", "<cmd>FzfLua buffers<CR>" },
	-- 	{ "<leader>o", "<cmd>FzfLua lsp_document_symbols<CR>" },
	-- 	{ "<leader>;", "<cmd>FzfLua resume<CR>" },
	-- },
	config = function()
		-- local actions = require("fzf-lua.actions")
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
					["ctrl-m"] = function(selected, _)
						pcall(require("harpoon.mark").add_file, selected[1])
					end,
				},
			},
		})
	end,
}
