return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "folke/neodev.nvim" },
	},
	config = function()
		require("neodev").setup()

		-- Diagnostic
		vim.diagnostic.config({
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
				texthl = hl,
				numhl = hl,
				linehl = hl,
			})
		end

		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
		vim.keymap.set("n", "<leader>D", vim.diagnostic.open_float)

		-- LSP setting
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
				local client = vim.lsp.get_client_by_id(args.data.client_id)

				if client.name == "tsserver" or client.name == "rust_analyzer" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end

				local opts = { noremap = true, silent = true, buffer = bufnr }

				vim.keymap.set("n", "gh", function()
					vim.lsp.buf.format({
						async = true,
						filter = function(c)
							return c.name == "null-ls"
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
				vim.keymap.set({ "n", "x" }, "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
			end,
		})

		local lspconfig = require("lspconfig")
		local lsp_defaults = lspconfig.util.default_config
		local mason_lspconfig = require("mason-lspconfig")

		lsp_defaults.capabilities =
			vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

		local servers = {
			lua_ls = {},
			-- clangd = {},
			gopls = {},
			pyright = {},
			-- rust_analyzer = {},
			tsserver = {},
			tailwindcss = {},
		}

		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
		})

		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					settings = servers[server_name],
				})
			end,
		})
	end,
}
