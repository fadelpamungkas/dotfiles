return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
			-- { "folke/neodev.nvim", opts = {} },
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

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local ft = vim.bo[bufnr].filetype
					local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0
					local opts = { noremap = true, silent = true, buffer = bufnr }

					vim.keymap.set("n", "<leader>D", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

					if vim.lsp.inlay_hint then
						vim.keymap.set("n", "<leader>l", function()
							vim.lsp.inlay_hint(0, nil)
						end)
					end

					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gi", "<cmd>TroubleToggle lsp_implementations<cr>", opts)
					vim.keymap.set("n", "gr", "<cmd>TroubleToggle lsp_references<cr>", opts)
					vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gh", function()
						vim.lsp.buf.format({
							async = true,
							filter = function(c)
								if have_nls then
									return c.name == "null-ls"
								end
								return c.name ~= "null-ls"
							end,
						})
					end, opts)
				end,
			})

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
						staticcheck = true,
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
				-- clangd = {},
				-- pyright = {},
				-- rust_analyzer = {}, -- handled by rust-tools.nvim
				-- tsserver = {},
				-- tailwindcss = {},
			}

			mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })
			mason_lspconfig.setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({ settings = servers[server_name] })
				end,
			})
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "BufReadPre",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = function()
			local null_ls = require("null-ls")
			return {
				sources = {
					null_ls.builtins.formatting.prettierd,
					null_ls.builtins.formatting.gofmt,
					null_ls.builtins.formatting.goimports,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.isort,
					null_ls.builtins.code_actions.eslint,
					null_ls.builtins.diagnostics.eslint_d,
					null_ls.builtins.diagnostics.golangci_lint,
					null_ls.builtins.diagnostics.flake8,
					null_ls.builtins.formatting.rustfmt.with({
						extra_args = function(params)
							local Path = require("plenary.path")
							local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")

							if cargo_toml:exists() and cargo_toml:is_file() then
								for _, line in ipairs(cargo_toml:readlines()) do
									local edition = line:match([[^edition%s*=%s*%"(%d+)%"]])
									if edition then
										return { "--edition=" .. edition }
									end
								end
							end
							-- default edition when we don't find `Cargo.toml` or the `edition` in it.
							return { "--edition=2021" }
						end,
					}),
				},
			}
		end,
	},
}
