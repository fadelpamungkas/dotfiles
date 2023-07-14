return {
	"anuvyklack/hydra.nvim",
	keys = { "<leader>a", "<leader>g", "<leader>x" },
	config = function()
		local hydra = require("hydra")
		local cmd = require("hydra.keymap-util").cmd

		hydra({
			name = "Activate",
			config = {
				color = "amaranth",
				invoke_on_body = true,
			},
			mode = { "n", "x" },
			body = "<Leader>a",
			heads = {
				{ "u", cmd("silent! %foldopen! | UndotreeToggle"), { exit = true, desc = "undotree" } },
				{
					"p",
					function()
						if require("peek").is_open() then
							require("peek").close()
						else
							require("peek").open()
						end
					end,
					{ exit = true, desc = "Peek Markdown" },
				},
				{ "<Esc>", nil, { exit = true } },
				{ "q", nil, { exit = true } },
			},
		})

		local gitsigns = require("gitsigns")

		hydra({
			name = "Git",
			config = {
				buffer = bufnr,
				color = "pink",
				invoke_on_body = true,
				on_enter = function()
					vim.cmd("mkview")
					vim.cmd("silent! %foldopen!")
					vim.bo.modifiable = false
					-- gitsigns.toggle_signs(true)
					gitsigns.toggle_linehl(true)
				end,
				on_exit = function()
					local cursor_pos = vim.api.nvim_win_get_cursor(0)
					vim.cmd("loadview")
					vim.api.nvim_win_set_cursor(0, cursor_pos)
					vim.cmd("normal zv")
					-- gitsigns.toggle_signs(false)
					gitsigns.toggle_linehl(false)
					gitsigns.toggle_deleted(false)
				end,
			},
			mode = { "n", "x" },
			body = "<leader>g",
			heads = {
				{
					"J",
					function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gitsigns.next_hunk()
						end)
						return "<Ignore>"
					end,
					{ expr = true },
				},
				{
					"K",
					function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gitsigns.prev_hunk()
						end)
						return "<Ignore>"
					end,
					{ expr = true, desc = "jump" },
				},
				{ "p", gitsigns.preview_hunk, { desc = "preview" } },
				{ "u", gitsigns.undo_stage_hunk, { desc = "undo" } },
				{ "d", gitsigns.toggle_deleted, { nowait = true, desc = "deleted" } },
				{ "S", gitsigns.stage_buffer },
				{ "s", ":Gitsigns stage_hunk<CR>", { silent = true, desc = "stage" } },
				{
					"B",
					function()
						gitsigns.blame_line({ full = true })
					end,
				},
				{ "b", gitsigns.blame_line, { desc = "blame" } },
				{ "/", gitsigns.show, { exit = true, desc = "base" } },
				{ "D", "<Cmd>DiffviewOpen<CR>", { exit = true, desc = "diff" } },
				{ "n", "<Cmd>Neogit<CR>", { exit = true, desc = "Neogit" } },
				{ "q", nil, { exit = true, nowait = true } },
				{ "<Esc>", nil, { exit = true, nowait = true } },
			},
		})

		local dap = require("dap")
		local hintDap = [[
		 _n_: step over   _s_: Start/Continue   _b_: Breakpoint       _u_: Toggle UI
		 _i_: step into   _x_: Disconnect       _K_: Hover Variables  _r_: Toggle Repl
		 _o_: step out    _c_: to cursor        _E_: Evaluate         _C_: Close UI
		 ^
		 ^ ^              _X_: Quit             _q_: exit
		]]

		hydra({
			name = "Dap",
			hint = hintDap,
			config = {
				buffer = bufnr,
				color = "pink",
				invoke_on_body = true,
				hint = {
					position = "bottom",
					border = "rounded",
				},
			},
			mode = { "n", "x" },
			body = "<leader>x",
			heads = {
				{ "C", "<cmd>lua require('dapui').close()<cr>:DapVirtualTextForceRefresh<cr>", { silent = true } },
				{ "u", "<cmd>lua require('dapui').toggle()<cr>", { silent = true } },
				{ "E", "<cmd>lua require('dapui').eval()<cr>", { silent = true } },
				{ "K", "<cmd>lua require('dap.ui.widgets').hover()<cr>", { silent = true } },
				{ "X", dap.close, { silent = true } },
				{ "b", dap.toggle_breakpoint, { silent = true } },
				{ "c", dap.run_to_cursor, { silent = true } },
				{ "i", dap.step_into, { silent = true } },
				{ "n", dap.step_over, { silent = true } },
				{ "o", dap.step_out, { silent = true } },
				{ "r", dap.repl.toggle, { silent = true } },
				{ "s", dap.continue, { silent = true } },
				{
					"x",
					"<cmd>lua require'dap'.disconnect({ terminateDebuggee = false })<cr>",
					{ exit = true, silent = true },
				},
				{ "q", nil, { exit = true, nowait = true } },
			},
		})
	end,
}
