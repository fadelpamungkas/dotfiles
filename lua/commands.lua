-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		require("vim.highlight").on_yank()
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

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = {
		"qf",
		"help",
		"man",
		"lspinfo",
		"spectre_panel",
		"tsplayground",
		"PlenaryTestPopup",
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

-- Leap
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
		-- etc.
	end,
})
