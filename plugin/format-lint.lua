-- conform.nvim
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require("conform").setup({
  formatters_by_ft = {
    javascriptreact = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    markdown = { "prettier" },
    python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
    html = { "prettier" },
    yaml = { "prettier" },
    json = { "prettier" },
    css = { "prettier" },
    lua = { "stylua" },
    go = { "gofumpt", "golangci-lint", "goimports", "golines" },
    rust = { "rustfmt" },
    dockerfile = { "hadolint" },
    toml = { "taplo" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    zig = { "zigfmt" },
    java = { "google-java-format" },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
})

vim.keymap.set({ "n", "v" }, "gh", function()
  require("conform").format({ async = true }, function(err, did_edit)
    if not err then
      local mode = vim.api.nvim_get_mode().mode
      if vim.startswith(string.lower(mode), "v") then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
      end
      if did_edit then
        vim.notify("Formatted", vim.log.levels.INFO, { title = "Conform" })
      end
    end
  end)
end)

-- nvim-lint
local lint = require("lint")

lint.linters_by_ft = {
  javascriptreact = { "eslint" },
  typescriptreact = { "eslint" },
  javascript = { "eslint" },
  typescript = { "eslint" },
  python = { "ruff", "mypy" },
  css = { "stylelint" },
  go = { "golangcilint" },
  rust = { "clippy" },
  dockerfile = { "hadolint" },
  c = { "clangtidy" },
  cpp = { "clangtidy" },
}

lint.linters.luacheck.args = {
  globals = { "vim" },
}

vim.api.nvim_create_autocmd({
  "BufReadPost",
  "InsertLeave",
  "TextChanged",
  "FocusGained",
}, {
  group = vim.api.nvim_create_augroup("CodeLinting", {}),
  pattern = "*",
  callback = function()
    lint.try_lint()
  end,
})
