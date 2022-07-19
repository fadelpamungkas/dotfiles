-- mappings.
-- see `:help vim.diagnostic.*` for documentation on any of the below functions
vim.diagnostic.config({
  virtual_text = false,
  -- virtual_text = {
  --   prefix = '●', -- could be '●', '▎', 'x'
  -- },
  signs = false,
  underline = false,
  update_in_insert = true,
  severity_sort = false,
  float = {
    focusable = false,
    style = "minimal",
    source = "always",
    prefix = "",
  },
})

vim.cmd [[
  highlight! DiagnosticLineNrError guibg=#51202A
  highlight! DiagnosticLineNrWarn guibg=#51412A
  highlight! DiagnosticLineNrInfo guibg=#1E535D
  highlight! DiagnosticLineNrHint guibg=#1E205D

  sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
  sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
  sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
  sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint
]]

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>ds', '<cmd>lua vim.diagnostic.enable()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>dh', '<cmd>lua vim.diagnostic.disable()<cr>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
-- vim.api.nvim_set_keymap('n', '<leader>dq', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>dq', '<cmd>TroubleToggle document_diagnostics<cr>', opts)

-- add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- show diagnostic on cursorhold
  --   vim.cmd [[autocmd! cursorhold,cursorholdi * lua vim.diagnostic.open_float(nil, {focus=false})]]
  --   vim.api.nvim_create_autocmd("cursorhold", {
  --
  --   buffer = bufnr,
  --   callback = function()
  --     local opts = {
  --       focusable = false,
  --       close_events = { "bufleave", "cursormoved", "insertenter", "focuslost" },
  --       border = 'rounded',
  --       source = 'always',
  --       prefix = ' ',
  --       scope = 'cursor',
  --     }
  --     vim.diagnostic.open_float(nil, opts)
  --   end
  -- })
  --
  if client.name == 'tsserver' then
		client.resolved_capabilities.document_formatting = false
  end

  -- enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- mappings.
  -- see `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ci', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ct', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';;', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl',
    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>td', '<cmd>TroubleToggle definitions<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ti', '<cmd>TroubleToggle implementations<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>tt', '<cmd>TroubleToggle type_definitions<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>tr', '<cmd>TroubleToggle references<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cq', '<cmd>TroubleToggle quickfix<cr>', opts)
end

-- enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'gopls', 'rust_analyzer', 'pyright', 'sumneko_lua', 'tsserver', 'tailwindcss', 'eslint' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
