-- gitsigns.nvim
require("gitsigns").setup({
  signcolumn = true,
  numhl = false,
})
vim.keymap.set("n", "gp", function()
  require("gitsigns").toggle_linehl()
  require("gitsigns").toggle_deleted()
  require("gitsigns").toggle_word_diff()
end)
vim.keymap.set("n", "gP", function()
  require("gitsigns").preview_hunk_inline()
end)

-- neogit
require("neogit").setup({
  disable_hint = true,
  disable_commit_confirmation = true,
  disable_insert_on_commit = false,
  integrations = { diffview = true },
})
vim.keymap.set("n", "<leader>g", "<cmd>Neogit<cr>")

-- diffview.nvim
require("diffview").setup({
  use_icons = false,
  view = {
    merge_tool = {
      layout = "diff4_mixed",
      disable_diagnostics = true,
      winbar_info = true,
    },
  },
})

-- codediff.nvim
require("codediff").setup({})

-- Clipboard comparison using codediff (normal mode: buffer vs clipboard)
vim.keymap.set("n", "<leader>vc", function()
  local tmpdir = vim.fn.tempname()
  vim.fn.mkdir(tmpdir, "p")
  local buf_file = tmpdir .. "/buffer"
  local clip_file = tmpdir .. "/clipboard"
  vim.fn.writefile(vim.api.nvim_buf_get_lines(0, 0, -1, false), buf_file)
  vim.fn.writefile(vim.split(vim.fn.getreg("+"), "\n"), clip_file)
  vim.cmd("CodeDiff file " .. buf_file .. " " .. clip_file)
end)

-- Clipboard comparison using codediff (visual mode: selection vs clipboard)
vim.keymap.set("v", "<leader>vc", function()
  local tmpdir = vim.fn.tempname()
  vim.fn.mkdir(tmpdir, "p")
  local sel_file = tmpdir .. "/selection"
  local clip_file = tmpdir .. "/clipboard"
  vim.cmd('normal! "zy')
  local selection = vim.split(vim.fn.getreg("z"), "\n")
  vim.fn.writefile(selection, sel_file)
  vim.fn.writefile(vim.split(vim.fn.getreg("+"), "\n"), clip_file)
  vim.cmd("CodeDiff file " .. sel_file .. " " .. clip_file)
end)
