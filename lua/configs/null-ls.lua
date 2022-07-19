local present, null_ls = pcall(require, "null-ls")
if not present then
  return
end

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.rustywind,
    -- null_ls.builtins.formatting.eslint_d,
    -- null_ls.builtins.formatting.buf,
    -- null_ls.builtins.formatting.pg_format,
    -- null_ls.builtins.formatting.stylua,
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
