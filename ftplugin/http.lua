vim.keymap.set("n", "<C-b>", ":lua require('kulala').jump_prev()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-f>", ":lua require('kulala').jump_next()<CR>", { noremap = true, silent = true })
