return {
	"akinsho/toggleterm.nvim",
	cmd = "ToggleTerm",
	keys = { "<C-t>", "<C-/>", "<leader>e" },
	opts = function()
		require("toggleterm").setup({
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			open_mapping = [[<c-t>]],
			direction = "tab",
			on_open = function(term)
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
		})

		function _G.set_terminal_keymaps()
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { noremap = true })
			vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], { noremap = true })
			vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], { noremap = true })
			vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], { noremap = true })
			vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], { noremap = true })
		end

		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

		local Terminal = require("toggleterm.terminal").Terminal

		local vterm = Terminal:new({ direction = "vertical", hidden = true })
		function _VTERM_TOGGLE()
			vterm:toggle()
		end

		local lf = Terminal:new({ direction = "tab", cmd = "lf" })
		function _LF_TOGGLE()
			lf:toggle()
		end
		vim.keymap.set("n", "<leader>e", "<cmd>lua _LF_TOGGLE()<CR>")
		vim.keymap.set("n", "<c-/>", "<cmd>lua _VTERM_TOGGLE()<CR>")
	end,
}
