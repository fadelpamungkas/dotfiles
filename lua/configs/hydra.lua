local present, hydra = pcall(require, "hydra")
if not present then
	return
end

local cmd = require("hydra.keymap-util").cmd

local hint = [[
                 _f_: files       _m_: marks
   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    _o_: old files   _g_: live grep
  🭉🭁🭠🭘    🭣🭕🭌🬾   _p_: projects    _/_: search in file
  🭅█ ▁     █🭐
  ██🬿      🭊██   _r_: resume      _u_: undotree
 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  _h_: vim help    _c_: colorscheme
 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  _k_: keymaps     _;_: commands history 
                 _O_: options     _?_: search history
 ^
                 _<Enter>_: Telescope           _<Esc>_ / _q_
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
		{ "f", cmd("Telescope find_files") },
		{ "g", cmd("Telescope live_grep") },
		{ "o", cmd("Telescope oldfiles"), { desc = "recently opened files" } },
		{ "h", cmd("Telescope help_tags"), { desc = "vim help" } },
		{ "m", cmd("MarksListBuf"), { desc = "marks" } },
		{ "k", cmd("Telescope keymaps") },
		{ "O", cmd("Telescope vim_options") },
		{ "r", cmd("Telescope resume") },
		{ "p", cmd("Telescope projects"), { desc = "projects" } },
		{ "/", cmd("Telescope current_buffer_fuzzy_find"), { desc = "search in file" } },
		{ "?", cmd("Telescope search_history"), { desc = "search history" } },
		{ ";", cmd("Telescope command_history"), { desc = "command-line history" } },
		{ "c", cmd("Telescope colorscheme"), { desc = "colorscheme" } },
		{ "u", cmd("silent! %foldopen! | UndotreeToggle"), { desc = "undotree" } },
		{ "<Enter>", cmd("Telescope"), { exit = true, desc = "list all pickers" } },
		{ "<Esc>", nil, { exit = true, nowait = true } },
		{ "q", nil, { exit = true, nowait = true } },
	},
})

local hintOpt = [[
  ^ ^        Activate
  ^
  _o_ Symbols Outline
  _l_ Eyeliner
  _c_ Virtual Context
  _t_ Typebreak

  _h_ cmdheight
  _s_ signcolumn
  _n_ %{nu} number
  _r_ %{rnu} relativenumber
  _v_ %{ve} virtualedit
  _w_ %{wrap} wrap
  ^
       ^^^^                _<Esc>_ / _q_
]]

-- _e_ Enable Diagnostic
-- _d_ Disable Diagnostic
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
		-- { 'e', cmd 'lua vim.diagnostic.enable()', { exit = true, desc = 'Enable Diagnostic' } },
		-- { 'd', cmd 'lua vim.diagnostic.disable()', { exit = true, desc = 'Disable Diagnostic' } },

		{ "o", cmd("SymbolsOutline"), { exit = true, desc = "Indentation" } },
		{ "l", cmd("EyelinerToggle"), { exit = true, desc = "Indentation" } },
		{ "c", cmd("NvimContextVtToggle"), { exit = true, desc = "Virtual Context" } },
		{ "t", require("typebreak").start, { exit = true, desc = "Typebreak" } },
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
				if vim.o.signcolumn == "auto" then
					vim.o.signcolumn = "no"
				else
					vim.o.signcolumn = "auto"
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
					-- Dealing with word wrap:
					-- If cursor is inside very long line in the file than wraps
					-- around several rows on the screen, then 'j' key moves you to
					-- the next line in the file, but not to the next row on the
					-- screen under your previous position as in other editors. These
					-- bindings fixes this.
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
 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
 ^
 ^ ^              _g_: Neogit              _<Esc>_ / _q_: exit
]]

hydra({
	name = "Git",
	hint = hintGit,
	config = {
		buffer = bufnr,
		color = "pink",
		invoke_on_body = true,
		hint = {
			border = "rounded",
			position = "bottom",
		},
		on_enter = function()
			vim.cmd("mkview")
			vim.cmd("silent! %foldopen!")
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
			{ expr = true, desc = "next hunk" },
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
			{ expr = true, desc = "prev hunk" },
		},
		{
			"s",
			function()
				local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
				if mode == "V" then -- visual-line mode
					local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
					vim.api.nvim_feedkeys(esc, "x", false) -- exit visual mode
					vim.cmd("'<,'>Gitsigns stage_hunk")
				else
					vim.cmd("Gitsigns stage_hunk")
				end
			end,
			{ desc = "stage hunk" },
		},
		{ "u", gitsigns.undo_stage_hunk, { desc = "undo last stage" } },
		{ "S", gitsigns.stage_buffer, { desc = "stage buffer" } },
		{ "p", gitsigns.preview_hunk, { desc = "preview hunk" } },
		{ "d", gitsigns.toggle_deleted, { nowait = true, desc = "toggle deleted" } },
		{ "b", gitsigns.blame_line, { desc = "blame" } },
		{
			"B",
			function()
				gitsigns.blame_line({ full = true })
			end,
			{ desc = "blame show full" },
		},
		{ "/", gitsigns.show, { exit = true, desc = "show base file" } }, -- show the base of the file
		{
			"g",
			function()
				vim.cmd("Neogit")
			end,
			{ exit = true, desc = "Neogit" },
		},
		{ "<Esc>", nil, { exit = true, nowait = true, desc = "exit" } },
		{ "q", nil, { exit = true, nowait = true, desc = "exit" } },
	},
})
