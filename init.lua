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
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.inccommand = "split"
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.undofile = true
opt.wrap = false
opt.cursorline = true
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 2
opt.laststatus = 3
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = false

g.mapleader = " "
g.maplocalleader = " "
map("n", "<Space>", "<Nop>", { silent = true })

map("i", "jk", "<Esc>")

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

map("i", "(<CR>", "(<CR>)<Esc>O")
map("i", "{<CR>", "{<CR>}<Esc>O")
map("i", "`<CR>", "`<CR>`<Esc>O")

map("n", "<Leader>mb", "<cmd>%!jq -c .<CR>")
map("v", "<Leader>mb", ":'<,'>!jq -c .<CR>")
map("n", "<Leader>mc", ":w !jq -c . | pbcopy<CR><CR>")
map("v", "<Leader>mc", ":w !jq -c . | pbcopy<CR><CR>")
map("n", "<Leader>M", "<cmd>%!jq .<CR>")
map("v", "<Leader>M", ":'<,'>!jq .<CR>")

map("n", "<leader>u", "<cmd>UndotreeToggle<CR>")

-- PackChanged hooks (MUST come before vim.pack.add)
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
    if name == "codediff.nvim" and kind == "install" then
      if not ev.data.active then
        vim.cmd.packadd("codediff.nvim")
      end
      vim.cmd("CodeDiff install")
    end
  end,
})

vim.pack.add({
  -- Dependencies
  "https://github.com/nvim-lua/plenary.nvim",

  -- Colorschemes
  "https://github.com/oskarnurm/koda.nvim",

  -- Treesitter
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",

  -- Completion
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/xzbdmw/colorful-menu.nvim",

  -- LSP support
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/b0o/schemastore.nvim",

  -- Formatting & Linting
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",

  -- Git
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/NeogitOrg/neogit",
  "https://github.com/esmuellert/codediff.nvim",

  -- Navigation & Search
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/elanmed/fzf-lua-frecency.nvim",
  "https://github.com/folke/flash.nvim",

  -- Editing
  { src = "https://github.com/kylechui/nvim-surround", version = vim.version.range("*") },
  "https://github.com/Wansmer/treesj",

  -- UI
  "https://github.com/folke/trouble.nvim",
  "https://github.com/MagicDuck/grug-far.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",

  -- AI
  "https://github.com/zbirenbaum/copilot.lua",

  -- DAP
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/miroshQa/debugmaster.nvim",

  -- Undo
  "https://github.com/mbbill/undotree",

  -- Language specific
  "https://github.com/mfussenegger/nvim-jdtls",
  "https://github.com/mistweaverco/kulala.nvim",
})

-- vim.pack convenience commands
vim.api.nvim_create_user_command("PackUpdate", function()
  vim.pack.update()
end, {})
vim.api.nvim_create_user_command("PackList", function()
  local plugins = vim.pack.get()
  table.sort(plugins, function(a, b)
    return a.spec.name < b.spec.name
  end)
  for _, p in ipairs(plugins) do
    print(string.format("%-35s %s  %s", p.spec.name, p.active and "+" or "-", p.rev:sub(1, 8)))
  end
end, {})

-- Colorscheme (koda available via :colorscheme koda, Lunaperche is default)
require("koda").setup({
  transparent = true,
  auto = false,
  cache = true,
})
vim.cmd("colorscheme koda")

-- Statusline
require("statusline").setup()

-- Commands and autocmds (deferred)
vim.schedule(function()
  require("commands")
end)

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "FlashMatch", { fg = "lightgrey" })
    vim.api.nvim_set_hl(0, "FlashLabel", { fg = "orange" })
    vim.api.nvim_set_hl(0, "FlashCurrent", { fg = "cyan" })
    for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
      local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
      if hl.bold then
        hl.bold = false
        vim.api.nvim_set_hl(0, group, hl)
      end
    end
  end,
})

vim.filetype.add({
  extension = {
    templ = "templ",
    ["http"] = "http",
    ["java"] = "java",
  },
})

vim.api.nvim_create_user_command("Lunaperche", function()
  vim.o.background = "dark"
  vim.cmd.colorscheme("lunaperche")
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "ModeMsg", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "DiffAdd", { fg = "#66c266", bg = "#2a3a2a" })
  vim.api.nvim_set_hl(0, "DiffChange", { fg = "#c2c266", bg = "#3a3a2a" })
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#c26666", bg = "#3a2a2a" })
  vim.api.nvim_set_hl(0, "DiffText", { fg = "#ffffff", bg = "#4a4a2a" })
end, {})

vim.api.nvim_create_user_command("Default", function()
  vim.cmd.colorscheme("default")
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "ModeMsg", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", fg = "white" })
  vim.o.background = "dark"
end, {})

vim.cmd("Lunaperche")
