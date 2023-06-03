return {
	"anuvyklack/hydra.nvim",
	keys = { "<leader>a", "<leader>g", "<leader>t", "<leader>x" },
	config = function()
		local hydra = require("hydra")
		local cmd = require("hydra.keymap-util").cmd

		local hint = [[
                 
   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    _j_: jumplist    _m_: marks
  🭉🭁🭠🭘    🭣🭕🭌🬾   _r_: resume      _R_: registers
  🭅█ ▁     █🭐   _h_: vim help    _c_: colorscheme
  ██🬿      🭊██   _k_: keymaps     _;_: commands history 
 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  _o_: options     _?_: search history
 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  
                 _t_: Telescope           _<Esc>_ / _q_ 

]]

		hydra({
			name = "Telescope",
			hint = hint,
			config = {
				color = "teal",
				invoke_on_body = true,
				hint = {
					position = "bottom",
					border = "rounded",
				},
			},
			mode = "n",
			body = "<Leader>t",
			heads = {
				{ "j", cmd("Telescope jumplist") },
				{ "m", cmd("Telescope marks") },
				{ "r", cmd("Telescope resume") },
				{ "h", cmd("Telescope help_tags") },
				{ "k", cmd("Telescope keymaps") },
				{ "o", cmd("Telescope vim_options") },
				{ "R", cmd("Telescope registers") },
				{ "c", cmd("Telescope colorscheme") },
				{ "?", cmd("Telescope search_history") },
				{ ";", cmd("Telescope command_history") },
				{ "t", cmd("Telescope"), { exit = true } },
				{ "<Esc>", nil, { exit = true, nowait = true } },
				{ "q", nil, { exit = true, nowait = true } },
			},
		})

		local hintOpt = [[
  ^ ^        Activate
  ^
  _c_ Colorizer
  _o_ Symbols Outline
  _u_ Undotree

  _l_ laststatus
  _h_ cmdheight
  _s_ signcolumn
  _n_ %{nu} number
  _r_ %{rnu} relativenumber
  _v_ %{ve} virtualedit
  _w_ %{wrap} wrap
  ^
       ^^^^                _<Esc>_ / _q_
]]

		hydra({
			name = "Activate",
			hint = hintOpt,
			config = {
				color = "amaranth",
				invoke_on_body = true,
				hint = {
					border = "rounded",
					position = "bottom",
				},
			},
			mode = { "n", "x" },
			body = "<Leader>a",
			heads = {
				{ "c", cmd("ColorizerToggle"), { exit = true, desc = "Colorizer" } },
				{ "o", cmd("SymbolsOutline"), { exit = true, desc = "Symbol" } },
				{ "u", cmd("silent! %foldopen! | UndotreeToggle"), { exit = true, desc = "undotree" } },
				{
					"l",
					function()
						if vim.o.laststatus > 2 then
							vim.o.laststatus = 0
						else
							vim.o.laststatus = vim.o.laststatus + 1
						end
					end,
					{ desc = "laststatus" },
				},
				{
					"h",
					function()
						if vim.o.cmdheight == 1 then
							vim.o.cmdheight = 0
						else
							vim.o.cmdheight = 1
						end
					end,
					{ desc = "cmdheight" },
				},
				{
					"s",
					function()
						if vim.o.signcolumn == "yes" then
							vim.o.signcolumn = "no"
						else
							vim.o.signcolumn = "yes"
						end
					end,
					{ desc = "signcolumn" },
				},
				{
					"n",
					function()
						if vim.o.number == true then
							vim.o.number = false
						else
							vim.o.number = true
						end
					end,
					{ desc = "number" },
				},
				{
					"r",
					function()
						if vim.o.relativenumber == true then
							vim.o.relativenumber = false
						else
							vim.o.number = true
							vim.o.relativenumber = true
						end
					end,
					{ desc = "relativenumber" },
				},
				{
					"v",
					function()
						if vim.o.virtualedit == "all" then
							vim.o.virtualedit = "block"
						else
							vim.o.virtualedit = "all"
						end
					end,
					{ desc = "virtualedit" },
				},
				{
					"w",
					function()
						if vim.o.wrap ~= true then
							vim.o.wrap = true
							vim.keymap.set("n", "k", function()
								return vim.v.count > 0 and "k" or "gk"
							end, { expr = true, desc = "k or gk" })
							vim.keymap.set("n", "j", function()
								return vim.v.count > 0 and "j" or "gj"
							end, { expr = true, desc = "j or gj" })
						else
							vim.o.wrap = false
							vim.keymap.del("n", "k")
							vim.keymap.del("n", "j")
						end
					end,
					{ desc = "wrap" },
				},
				{ "<Esc>", nil, { exit = true } },
				{ "q", nil, { exit = true } },
			},
		})

		local gitsigns = require("gitsigns")

		local hintGit = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full 
 _D_: DiffView    _S_: stage buffer      _/_: show base file
 ^
 ^ ^              _n_: Neogit              _<Esc>_ / _q_: exit
]]

		hydra({
			name = "Git",
			-- hint = hintGit,
			config = {
				buffer = bufnr,
				color = "pink",
				invoke_on_body = true,
				hint = {
					border = "rounded",
				},
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
