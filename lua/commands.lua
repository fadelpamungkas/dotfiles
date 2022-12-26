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
		"startuptime",
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

vim.api.nvim_create_autocmd("User", {
	pattern = "AlphaReady",
	desc = "disable status and tabline for alpha",
	callback = function()
		vim.go.laststatus = 0
		vim.opt.showtabline = 0
	end,
})
vim.api.nvim_create_autocmd("BufUnload", {
	buffer = 0,
	desc = "enable status and tabline after alpha",
	callback = function()
		vim.go.laststatus = 3
		vim.opt.showtabline = 1
	end,
})
