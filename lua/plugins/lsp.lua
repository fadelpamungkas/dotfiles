local M = {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
}

function M.config()
	local mason_lspconfig = require("mason-lspconfig")
	local lspconfig = require("lspconfig")

	-- mappings.
	-- see `:help vim.diagnostic.*` for documentation on any of the below functions
	vim.diagnostic.config({
		-- virtual_text = false,
		virtual_text = {
			prefix = "●", -- could be '●', '▎', 'x'
		},
		signs = true,
		underline = false,
		update_in_insert = false,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			source = "always",
			prefix = "",
		},
	})

	local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, {
			-- text = icon,
			texthl = hl,
			numhl = hl,
			linehl = hl,
		})
	end

	-- vim.cmd([[lua vim.diagnostic.disable()]])

	vim.cmd([[
  highlight! DiagnosticSignError guibg=#51202A
  highlight! DiagnosticSignWarn guibg=#51412A
  highlight! DiagnosticSignInfo guibg=#1E535D
  highlight! DiagnosticSignHint guibg=#1E205D
  " sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl=DiagnosticLineNrError numhl=DiagnosticLineNrError
  " sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl=DiagnosticLineNrWarn numhl=DiagnosticLineNrWarn
  " sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl=DiagnosticLineNrInfo numhl=DiagnosticLineNrInfo
  " sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl=DiagnosticLineNrHint numhl=DiagnosticLineNrHint
]])

	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap("n", "<leader>dd", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
	vim.api.nvim_set_keymap("n", "<leader>ds", "<cmd>lua vim.diagnostic.enable()<cr>", opts)
	vim.api.nvim_set_keymap("n", "<leader>dh", "<cmd>lua vim.diagnostic.disable()<cr>", opts)
	-- vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
	-- vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
	-- vim.api.nvim_set_keymap('n', '<leader>dq', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
	vim.api.nvim_set_keymap("n", "<leader>dq", "<cmd>TroubleToggle document_diagnostics<cr>", opts)

	-- add additional capabilities supported by nvim-cmp
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

	-- use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer
	local on_attach = function(client, bufnr)
		if client.name == "tsserver" then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end

		-- enable completion triggered by <c-x><c-o>
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

		-- mappings.
		-- see `:help vim.lsp.*` for documentation on any of the below functions
		-- vim.api.nvim_buf_set_keymap(bufnr, 'n', ';;', '<cmd>lua vim.lsp.buf.format()<cr>', opts)
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "gh", function()
			vim.lsp.buf.format({
				filter = function()
					return client.name == "null-ls"
				end,
				bufnr = bufnr,
			})
		end, bufopts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>TroubleToggle lsp_definitions<cr>", opts)
		-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ci', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>TroubleToggle lsp_implementations<cr>", opts)
		-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>TroubleToggle lsp_references<cr>", opts)
		-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ct', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ct", "<cmd>TroubleToggle lsp_type_definitions<cr>", opts)

		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>wr",
			"<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>wl",
			"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>",
			opts
		)

		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cq", "<cmd>TroubleToggle quickfix<cr>", opts)
	end

	-- enable some language servers with the additional completion capabilities offered by nvim-cmp
	-- local servers = { 'gopls', 'rust_analyzer', 'pyright', 'sumneko_lua', 'tsserver', 'tailwindcss', 'eslint' }
	-- for _, lsp in ipairs(servers) do
	--   lspconfig[lsp].setup {
	--     on_attach = on_attach,
	--     capabilities = capabilities,
	--   }
	-- end

	-- Extension to bridge mason.nvim with the lspconfig plugin
	mason_lspconfig.setup({
		-- A list of servers to automatically install if they're not already installed.
		ensure_installed = {
			"sumneko_lua",
			"gopls",
			"tsserver",
			"tailwindcss",
			"rust_analyzer",
			"pyright",
		},
	})

	mason_lspconfig.setup_handlers({
		-- The first entry (without a key) will be the default handler
		-- and will be called for each installed server that doesn't have
		-- a dedicated handler.
		function(server_name) -- Default handler (optional)
			lspconfig[server_name].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end,
	})
end

return M
