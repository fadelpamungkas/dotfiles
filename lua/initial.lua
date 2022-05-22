vim.o.updatetime = 250
vim.opt.undofile = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.splitbelow = true -- Open new split below
vim.opt.splitright = true -- Open new split to the right

--Remap space as leader key
vim.api.nvim_set_keymap( 'n' , '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('i', 'jk','<Esc>')
vim.api.nvim_set_keymap( 'v' , '>', '>gv', { noremap = true })
vim.api.nvim_set_keymap( 'v' , '<', '<gv', { noremap = true })


-- vim.api.nvim_set_keymap( 'n' , '<C-Right>', '<cmd>:vertical resize +2<CR>', { noremap = true })
-- vim.api.nvim_set_keymap( 'n' , '<C-Left>', '<cmd>:vertical resize -2<CR>', { noremap = true })
-- vim.api.nvim_set_keymap( 'n' , '<c-up>', '<cmd>resize +2<CR>', { noremap = true })
-- vim.api.nvim_set_keymap( 'n' , '<c-down>', '<cmd>resize -2<CR>', { noremap = true })
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-l>', '<c-w>l')
vim.keymap.set('n', '<leader>sv', '<cmd>vsplit<CR>')
vim.keymap.set('n', '<leader>sh', '<cmd>split<CR>')


-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    require("vim.highlight").on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

