local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>Telescope find_files find_command=rg,--ignore,--files<CR>', opts) -- optional: --hidden
vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>Telescope live_grep<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>o', '<cmd>Telescope oldfiles<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>\'', '<cmd>Telescope registers<CR>', opts)

