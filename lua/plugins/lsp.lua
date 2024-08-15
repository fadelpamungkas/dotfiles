return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			vim.diagnostic.config({
				virtual_text = { prefix = "◼︎" }, -- could be '●', '▎', 'x'
				underline = false,
				severity_sort = true,
			})

			-- local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
			-- for type, _ in pairs(signs) do
			-- 	local hl = "DiagnosticSign" .. type
			-- 	vim.fn.sign_define(hl, { texthl = hl, numhl = hl, linehl = hl })
			-- end

			local lspconfig = require("lspconfig")
			local lsp_defaults = lspconfig.util.default_config
			local mason_lspconfig = require("mason-lspconfig")

			lsp_defaults.capabilities =
				vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = {
				lua_ls = {
					Lua = {
						hint = { enable = true },
						diagnostics = { globals = { "vim" } },
					},
				},
				gopls = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						gofumpt = true,
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
				eslint = {},
				-- clangd = {},
				-- pyright = {},
				-- rust_analyzer = {}, -- handled by rust-tools.nvim
				-- tsserver = {},
				-- tailwindcss = {},
			}
			local lsp_attach = function(client, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }

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
			end

			mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })
			mason_lspconfig.setup_handlers({
				function(server_name)
					-- lspconfig[server_name].setup({ settings = servers[server_name] })
					if server_name ~= "jdtls" then
						lspconfig[server_name].setup({
							on_attach = lsp_attach,
							capabilities = lsp_defaults.capabilities,
						})
					end
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = { { "gh", "<cmd>Format<cr>", mode = { "n", "v" } } },
		opts = {
			formatters_by_ft = {
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				markdown = { "prettier" },
				python = { "isort", "black" },
				html = { "prettier" },
				yaml = { "prettier" },
				json = { "prettier" },
				css = { "prettier" },
				lua = { "stylua" },
				go = { "goimports", "gofmt" },
			},
			format = {
				timeout_ms = 3000,
				async = false,
				quiet = false,
				lsp_fallback = true,
			},
			-- format_on_save = {},
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			-- local utils = require("core.utils")

			lint.linters_by_ft = {
				javascriptreact = { "eslint" },
				typescriptreact = { "eslint" },
				javascript = { "eslint" },
				typescript = { "eslint" },
				css = { "stylelint" },
				-- lua = { "luacheck" },
				go = { "golangcilint" },
			}

			lint.linters.luacheck.args = {
				globals = {
					"vim",
				},
			}

			local augroup = vim.api.nvim_create_augroup("CodeLinting", {})

			vim.api.nvim_create_autocmd({
				"BufReadPost",
				"InsertLeave",
				"TextChanged",
				"FocusGained",
			}, {
				pattern = "*",
				group = augroup,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
