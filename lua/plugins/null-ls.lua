return {
	"jose-elias-alvarez/null-ls.nvim",
	event = "BufReadPre",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			-- on_attach = function(client, bufnr)
			--   lsp_formatting(bufnr)
			-- end,
			sources = {
				null_ls.builtins.formatting.prettierd,
				null_ls.builtins.formatting.rustywind,
				null_ls.builtins.formatting.gofmt,
				null_ls.builtins.formatting.goimports,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.code_actions.eslint,
				null_ls.builtins.diagnostics.eslint_d,
				null_ls.builtins.diagnostics.golangci_lint,
				null_ls.builtins.diagnostics.flake8,
				-- null_ls.builtins.code_actions.refactoring,
				-- null_ls.builtins.formatting.eslint_d,
				-- null_ls.builtins.formatting.buf,
				-- null_ls.builtins.formatting.pg_format,
				-- null_ls.builtins.formatting.protolint,
				-- null_ls.builtins.formatting.puppet_lint,
				-- null_ls.builtins.formatting.dart_format,
				-- null_ls.builtins.formatting.terraform_fmt,
				-- null_ls.builtins.formatting.sqlfluff.with({
				-- extra_args = {"--dialect", "postgres"} -- change to your dialect
				-- }),
				-- null_ls.builtins.formatting.sqlformat,
				-- null_ls.builtins.formatting.sql_formatter,
				--
				-- null_ls.builtins.diagnostics.ansiblelint,
				-- null_ls.builtins.diagnostics.buf,
				-- null_ls.builtins.diagnostics.cfn_lint,
				-- null_ls.builtins.diagnostics.checkmake,
				-- null_ls.builtins.diagnostics.editorconfig_checker,
				-- null_ls.builtins.diagnostics.hadolint,
				-- null_ls.builtins.diagnostics.jsonlint,
				-- null_ls.builtins.diagnostics.protoc_gen_lint,
				-- null_ls.builtins.diagnostics.protolint,
				-- null_ls.builtins.diagnostics.puppet_lint,
				-- null_ls.builtins.diagnostics.yamllint,
			},
		})
	end,
}
