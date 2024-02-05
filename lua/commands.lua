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
