-- LSP auto commands
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local opts = { noremap = true, silent = true, buffer = args.buf }

		vim.keymap.set("n", "<leader>D", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

		vim.keymap.set("n", "<leader>l", function()
			vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
		end)

		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gi", "<cmd>Trouble lsp_implementations toggle<cr>", opts)
		vim.keymap.set("n", "gr", "<cmd>Trouble lsp_references toggle<cr>", opts)
		vim.keymap.set("n", "gL", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", opts)
		vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)
	end,
})

vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	callback = function()
		local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
		if ok and cl then
			vim.wo.cursorline = true
			vim.api.nvim_win_del_var(0, "auto-cursorline")
		end
	end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	callback = function()
		local cl = vim.wo.cursorline
		if cl then
			vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
			vim.wo.cursorline = false
		end
	end,
})

-- TODO: comment
vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
	callback = function()
		vim.cmd([[
        hi link TodoComment WarningMsg
        match TodoComment /\(TODO\|FIXME\|FIX\|ISSUE\|NOTE\|INFO\|WARN\|PERF\|TEST\):/
        ]])
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = {
		"qf",
		"help",
		"man",
		"vim",
		"lspinfo",
		"spectre_panel",
		"tsplayground",
		"PlenaryTestPopup",
		"rest_nvim_results",
	},
	callback = function()
		vim.cmd([[
    nnoremap <silent> <buffer> q <cmd>close<CR> 
    set nobuflisted 
    ]])
	end,
})

-- auto toggle highlight search
local ns = vim.api.nvim_create_namespace("toggle_hlsearch")

local function toggle_hlsearch(char)
	if vim.fn.mode() == "n" then
		local keys = { "<CR>", "n", "N", "*", "#", "?", "/" }
		local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))

		if vim.opt.hlsearch:get() ~= new_hlsearch then
			vim.opt.hlsearch = new_hlsearch
		end
	end
end

vim.on_key(toggle_hlsearch, ns)

-- Create a new scratch buffer
vim.api.nvim_create_user_command("Ns", function()
	vim.cmd([[
		execute 'vsplit | enew'
		setlocal buftype=nofile
		setlocal bufhidden=hide
		setlocal noswapfile
	]])
end, { nargs = 0 })

-- Compare clipboard to current buffer
vim.api.nvim_create_user_command("CompareClipboard", function()
	local ftype = vim.api.nvim_eval("&filetype") -- original filetype
	vim.cmd([[
		tabnew %
		Ns
		normal! P
		windo diffthis
	]])
	vim.cmd("set filetype=" .. ftype)
  vim.cmd("nnoremap <silent> <buffer> q <cmd>tabclose<CR>")
end, { nargs = 0 })

-- Assign it to a keymap
vim.keymap.set("n", "<leader>vc", "<cmd>CompareClipboard<cr>")

-- Compare clipboard to visual selection
vim.api.nvim_create_user_command("CompareClipboardSelection", function()
	vim.cmd([[
		" yank visual selection to z register
		normal! gv"zy
		" open new tab, set options to prevent save prompt when closing
		execute 'tabnew | setlocal buftype=nofile bufhidden=hide noswapfile'
		" paste z register into new buffer
		normal! V"zp
		Ns
		normal! Vp
		windo diffthis
	]])
  vim.cmd("nnoremap <silent> <buffer> q <cmd>tabclose<CR>")
end, {
	nargs = 0,
	range = true,
})

-- Assign it to a keymap
vim.keymap.set("v", "<leader>vc", "<esc><cmd>CompareClipboardSelection<cr>")

function _G.toggle_quickfix()
	local windows = vim.api.nvim_list_wins()

	for _, win in pairs(windows) do
		if vim.api.nvim_win_get_config(win).relative == "" then
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.bo[buf].buftype == "quickfix" then
				vim.cmd("cclose")
				return
			end
		end
	end

	vim.cmd("botright copen")
end

vim.keymap.set("n", "<leader>q", ":lua toggle_quickfix()<CR>", { noremap = true, silent = true })
