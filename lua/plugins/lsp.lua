return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "hrsh7th/cmp-nvim-lsp" },
		{
			"williamboman/mason-lspconfig.nvim",
		},
		{
			"williamboman/mason.nvim",
			config = true,
		},
	},
	config = function()
		local mason_lspconfig = require("mason-lspconfig")
		local lspconfig = require("lspconfig")

		-- Diagnostic
		vim.diagnostic.config({
			-- virtual_text = false,
			virtual_text = {
				spacing = 4,
				prefix = "◼︎", -- could be '●', '▎', 'x'
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
		for type, _ in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, {
				-- text = icon,
				texthl = hl,
				numhl = hl,
				linehl = hl,
			})
		end

		local opts = { noremap = true, silent = true }
		vim.keymap.set("n", "<leader>D", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
		-- vim.keymap.set("n", "<leader>ds", "<cmd>lua vim.diagnostic.enable()<cr>", opts)
		-- vim.keymap.set("n", "<leader>dh", "<cmd>lua vim.diagnostic.disable()<cr>", opts)

		-- LSP setting
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		local on_attach = function(client, bufnr)
			if client.name == "tsserver" or client.name == "rust_analyzer" then
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end

			opts = { noremap = true, silent = true, buffer = bufnr }

			vim.keymap.set("n", "gh", function()
				vim.lsp.buf.format({
					filter = function(current)
						return current.name == "null-ls"
					end,
					bufnr = bufnr,
				})
			end, opts)
			vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
			vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
			vim.keymap.set("n", "gd", "<cmd>TroubleToggle lsp_definitions<cr>", opts)
			vim.keymap.set("n", "gi", "<cmd>TroubleToggle lsp_implementations<cr>", opts)
			vim.keymap.set("n", "gr", "<cmd>TroubleToggle lsp_references<cr>", opts)
			vim.keymap.set("n", "gt", "<cmd>TroubleToggle lsp_type_definitions<cr>", opts)
			vim.keymap.set("n", "gK", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
			-- vim.keymap.set("n", "gR", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
			vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
			vim.keymap.set("n", "<leader>cq", "<cmd>TroubleToggle quickfix<cr>", opts)
		end

		mason_lspconfig.setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"gopls",
				"tsserver",
				"tailwindcss",
				"pyright",
				"jsonls",
				"yamlls",
			},
		})

		mason_lspconfig.setup_handlers({
			function(server_name) -- Default handler (optional)
				lspconfig[server_name].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["rust_analyzer"] = function()
				local extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/"
				local codelldb_path = extension_path .. "adapter/codelldb"
				local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
				require("rust-tools").setup({
					server = {
						on_attach = on_attach,
					},
					capabilities = capabilities,
					dap = {
						adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
					},
				})
			end,
		})

		require("flutter-tools").setup({
			widget_guides = { enabled = true },
			dev_log = { enabled = true, open_cmd = "tabedit" },
			lsp = {
				color = {
					enabled = false,
					background = false,
					virtual_text = false,
				},
				on_attach = on_attach,
				capabilities = capabilities,
			},
		})
	end,
}
