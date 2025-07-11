local opt = vim.opt
local g = vim.g
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

if g.neovide ~= nil then
  vim.o.guifont = "Menlo:h14"
  g.neovide_cursor_antialiasing = true
  g.neovide_cursor_vfx_mode = ""
  g.neovide_cursor_animation_length = 0.05
  g.neovide_cursor_trail_size = 0
  g.neovide_scale_factor = 1
  g.neovide_transparency = 1
  g.transparency = 0.5
  vim.keymap.set("n", "<F11>", ":let g:neovide_fullscreen = !g:neovide_fullscreen<CR>")
end

vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)

opt.updatetime = 200
opt.background = "dark"
opt.showmatch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true
opt.inccommand = "split"
opt.autoindent = true
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.undofile = true
opt.wrap = false
opt.cursorline = true
opt.termguicolors = true
opt.splitbelow = true
opt.splitright = true
opt.completeopt = { "menu", "menuone", "noselect" }
opt.scrolloff = 2
opt.laststatus = 3
opt.sessionoptions = "buffers,folds,help,tabpages,winsize,resize,winpos"
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = false
-- opt.signcolumn = "yes"
-- opt.number = true
-- opt.relativenumber = true

-- Remap space as leader key
g.mapleader = " "
g.maplocalleader = " "
map("n", "<Space>", "<Nop>", { silent = true })

map("i", "jk", "<Esc>")
map("i", "<Esc>", "<Esc>")

map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("n", "<Right>", "<cmd>:vertical resize +1<CR>")
map("n", "<Left>", "<cmd>:vertical resize -1<CR>")
map("n", "<Up>", "<cmd>resize +1<CR>")
map("n", "<Down>", "<cmd>resize -1<CR>")

map({ "n", "t" }, "<c-j>", "<c-w>j")
map({ "n", "t" }, "<c-k>", "<c-w>k")
map({ "n", "t" }, "<c-h>", "<c-w>h")
map({ "n", "t" }, "<c-l>", "<c-w>l")

map("n", "<c-s>", [[:%s/\<<c-r><c-w>\>/<c-r><c-w>/gI<left><left><left>]])
map("n", "gV", "`[V`]")

map("x", "<leader>p", [["_dP]])
map("x", "<leader>P", [["_dp]])

map("n", "<leader>w", "<cmd>set wrap!<CR>")

-- map('n', '<tab>', ':cnext<CR>', { noremap = true, silent = true })
-- map('n', '<s-tab>', ':cprev<CR>', { noremap = true, silent = true })

-- Automatically Pair brackets, parethesis, and quotes
map("i", "(<CR>", "(<CR>)<Esc>O")
map("i", "{<CR>", "{<CR>}<Esc>O")
map("i", "`<CR>", "`<CR>`<Esc>O")
------------------------------

-- convert buffer (json) to one line/minified json and vice versa
map("n", "<Leader>mb", "<cmd>%!jq -c .<CR>")
map("v", "<Leader>mb", ":'<,'>!jq -c .<CR>")
map("n", "<Leader>mc", ":w !jq -c . | pbcopy<CR><CR>")
map("v", "<Leader>mc", ":w !jq -c . | pbcopy<CR><CR>")
map("n", "<Leader>M", "<cmd>%!jq .<CR>")
map("v", "<Leader>M", ":'<,'>!jq .<CR>")

require("lazyconfig")

-- Initialize statusline
require("statusline").setup()

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("commands")
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "FlashMatch", { fg = "lightgrey" })
    vim.api.nvim_set_hl(0, "FlashLabel", { fg = "orange" })
    vim.api.nvim_set_hl(0, "FlashCurrent", { fg = "cyan" })
  end,
})

-- additional filetypes
vim.filetype.add({
  extension = {
    templ = "templ",
    ["http"] = "http",
  },
})

vim.api.nvim_create_user_command("Lunaperche", function()
  vim.o.background = "dark"
  vim.cmd.colorscheme("lunaperche")
  vim.api.nvim_set_hl(0, "Normal", { bg = NONE })
  vim.api.nvim_set_hl(0, "ModeMsg", { bg = NONE })
  vim.api.nvim_set_hl(0, "StatusLine", { bg = NONE })

  -- Diff highlights (for diff mode and fugitive)
  vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#66c266", bg = "#2a3a2a" })
  vim.api.nvim_set_hl(0, "DiffChange", { fg = "#c2c266", bg = "#3a3a2a" })
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#c26666", bg = "#3a2a2a" })
  vim.api.nvim_set_hl(0, "DiffText", { fg = "#ffffff", bg = "#4a4a2a" })
end, {})

vim.api.nvim_create_user_command("Default", function()
  vim.cmd.colorscheme("default")
  vim.api.nvim_set_hl(0, "Normal", { bg = NONE })
  vim.api.nvim_set_hl(0, "ModeMsg", { bg = NONE })
  vim.api.nvim_set_hl(0, "StatusLine", { bg = NONE, fg = "white" })
  vim.o.background = "dark"
end, {})

-- Disable bold text formatting in all highlight groups
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- Remove bold from all highlight groups
    for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
      local hl = vim.api.nvim_get_hl_by_name(group, true)
      if hl.bold then
        hl.bold = nil
        vim.api.nvim_set_hl(0, group, hl)
      end
    end
  end,
})
vim.cmd("Lunaperche")
