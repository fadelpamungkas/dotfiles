local present, null_ls = pcall(require, "null-ls")
if not present then
	return
end

-- local lsp_formatting = function(bufnr)
--   vim.lsp.buf.format({
--     filter = function(client)
--       -- apply whatever logic you want (in this example, we'll only use null-ls)
--       return client.name == "null-ls"
--     end,
--     bufnr = bufnr,
--   })
-- end
--
-- -- add to your shared on_attach callback
-- local on_attach = function(client, bufnr)
--     if client.supports_method("textDocument/formatting") then
--         vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--         vim.api.nvim_create_autocmd("BufWritePre", {
--             group = augroup,
--             buffer = bufnr,
--             callback = function()
--                 lsp_formatting(bufnr)
--             end,
--         })
--     end
-- end

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
		null_ls.builtins.code_actions.eslint,
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.diagnostics.golangci_lint,
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
