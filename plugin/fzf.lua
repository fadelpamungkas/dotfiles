require("fzf-lua").setup({
  { "max-perf", "hide" },
  winopts = {
    border = "none",
    fullscreen = true,
    preview = {
      border = "none",
      delay = 0,
      scrollbar = false,
    },
  },
  files = {
    fd_opts = [[--color=never --type f --hidden --follow --exclude '.git' --exclude 'node_modules' --exclude '.npm']],
  },
  grep = {
    rg_opts = " --color=never --column --line-number --no-heading --smart-case --max-columns=4096 -g '!node_modules' -g '!.git' -g '!**/_build' -g '!deps' -g '!.elixir_ls' -g '!**/target' -g '!**/assets/node_modules' -g '!**/assets/vendor' -g '!.next' -g '!.vercel' -g '!**/build' -g '!**/out' -e",
  },
  keymap = {
    builtin = {
      true,
      ["<Esc>"] = "hide",
    },
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
  },
  fzf_colors = {
    ["bg+"] = { "bg", "PmenuSel" },
  },
})

vim.keymap.set("n", "<leader>f", "<cmd>lua require('fzf-lua-frecency').frecency({cwd_only = true})<CR>")
vim.keymap.set("n", "<leader>F", "<cmd>lua require'fzf-lua'.global()<CR>")
vim.keymap.set("n", "<leader>/", "<cmd>lua require'fzf-lua'.grep_curbuf()<CR>")
vim.keymap.set("n", "<leader>S", "<cmd>lua require'fzf-lua'.live_grep()<CR>")
vim.keymap.set("n", "<leader>,", "<cmd>lua require'fzf-lua'.resume()<CR>")
vim.keymap.set("n", "<leader>Gs", "<cmd>lua require'fzf-lua'.git_status()<CR>")
vim.keymap.set("n", "<leader>GC", "<cmd>lua require'fzf-lua'.git_commits()<CR>")
vim.keymap.set("n", "<leader>Gc", "<cmd>lua require'fzf-lua'.git_bcommits()<CR>")
vim.keymap.set("n", "<leader>Gb", "<cmd>lua require'fzf-lua'.git_branches()<CR>")
vim.keymap.set(
  "n",
  "<leader>t",
  "<cmd>lua require'fzf-lua'.grep({ search='(TODO:|FIXME:|FIX:|ISSUE:|NOTE:|INFO:|WARN:|PERF:|TEST:)', no_esc=true })<CR>"
)
