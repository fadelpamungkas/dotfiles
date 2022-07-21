local present, indent = pcall(require, "indent_blankline")
if not present then
  return
end

vim.api.nvim_set_keymap('n', '<c-i>', '<cmd>IndentBlanklineToggle!<CR>', { noremap = true })

-- vim.opt.list = true
-- vim.opt.listchars:append("eol:↴")
-- vim.opt.termguicolors = true

vim.cmd [[IndentBlanklineDisable!]]
vim.cmd [[highlight IndentBlanklineIndent1 guibg=NONE]]
vim.cmd [[highlight IndentBlanklineIndent2 guibg=#2F343F]]

indent.setup {
  -- show_end_of_file = false,
  -- show_current_context = true,
  -- show_current_context_start = true,
  char = " ",
  char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
  },
  space_char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
  },
  show_trailing_blankline_indent = false,
}
