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

-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	group = vim.api.nvim_create_augroup("kickstart-lsp-attach-format", { clear = true }),
-- 	-- This is where we attach the autoformatting for reasonable clients
-- 	callback = function(args)
-- 		local client_id = args.data.client_id
-- 		local client = vim.lsp.get_client_by_id(client_id)
-- 		local bufnr = args.buf
--
-- 		-- Only attach to clients that support document formatting
-- 		if not client.server_capabilities.documentFormattingProvider then
-- 			return
-- 		end
--
-- 		-- Tsserver usually works poorly. Sorry you work with bad languages
-- 		-- You can remove this line if you know what you're doing :)
-- 		if client.name == "tsserver" then
-- 			return
-- 		end
--
-- 		-- Create an autocmd that will run *before* we save the buffer.
-- 		--  Run the formatting command for the LSP that has just attached.
-- 		vim.api.nvim_create_autocmd("BufWritePre", {
-- 			group = get_augroup(client),
-- 			buffer = bufnr,
-- 			callback = function()
-- 				if not format_is_enabled then
-- 					return
-- 				end
--
-- 				vim.lsp.buf.format({
-- 					async = false,
-- 					filter = function(c)
-- 						return c.id == client.id
-- 					end,
-- 				})
-- 			end,
-- 		})
-- 	end,
-- })
