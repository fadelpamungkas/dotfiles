return {
	"akinsho/toggleterm.nvim",
	cmd = "ToggleTerm",
	keys = { "<C-/>", "<leader>e", "<leader>/" },
	opts = function()
		require("toggleterm").setup({
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			open_mapping = [[<c-/>]],
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = false,
			persist_mode = false,
			direction = "horizontal",
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
			on_open = function(term)
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
			on_close = function(term)
				vim.cmd([[echo "Closing terminal"]])
			end,
		})

		function _G.set_terminal_keymaps()
			local opts = { noremap = true }
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
			vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
			vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
			vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
			vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
		end

		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

		local Terminal = require("toggleterm.terminal").Terminal

		local vterm = Terminal:new({ direction = "vertical", hidden = true })
		function _VTERM_TOGGLE()
			vterm:toggle()
		end

		local lf = Terminal:new({ direction = "tab", cmd = "lf", hidden = true })
		function _LF_TOGGLE()
			lf:toggle()
		end
		vim.keymap.set("n", "<leader>e", "<cmd>lua _LF_TOGGLE()<CR>")
		vim.keymap.set("n", "<leader>/", "<cmd>lua _VTERM_TOGGLE()<CR>")
	end,
}
