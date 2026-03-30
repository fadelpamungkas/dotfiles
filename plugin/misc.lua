-- oil.nvim
require("oil").setup({
  default_file_explorer = true,
  use_default_keymaps = false,
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-o>"] = "actions.select",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-x>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["q"] = "actions.close",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["zr"] = "actions.refresh",
    ["zh"] = "actions.toggle_hidden",
  },
})
vim.keymap.set("n", "-", "<cmd>lua require('oil').open()<CR>")

-- flash.nvim
require("flash").setup({
  modes = { char = { jump_labels = true, multi_line = false } },
})
-- stylua: ignore start
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end)
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end)
vim.keymap.set("o", "r", function() require("flash").remote() end)
-- stylua: ignore end

-- nvim-surround
require("nvim-surround").setup({})

-- treesj
require("treesj").setup({ use_default_keymaps = false })
vim.keymap.set("n", "gJ", "<cmd>TSJToggle<cr>")

-- trouble.nvim
require("trouble").setup({
  icons = {
    indent = {
      top = "| ",
      middle = "+-",
      last = "`-",
      fold_open = "> ",
      fold_closed = "v ",
      ws = "  ",
    },
    folder_closed = "[ ] ",
    folder_open = "[>] ",
  },
  focus = true,
  fold_open = "v",
  fold_closed = ">",
  indent_lines = false,
  use_diagnostic_signs = true,
  padding = false,
  auto_jump = { "lsp_definitions", "lsp_implementations" },
  keys = {
    m = {
      action = function(view)
        view:filter({ buf = 0 }, { toggle = true })
      end,
      desc = "Toggle Current Buffer Filter",
    },
  },
})
vim.keymap.set("n", "<leader>d", "<cmd>Trouble diagnostics toggle<cr>")

-- grug-far.nvim
require("grug-far").setup({})
vim.keymap.set("v", "<leader>r", function()
  require("grug-far").open({
    prefills = { paths = vim.fn.expand("%") },
  })
end)
vim.keymap.set("n", "<leader>r", function()
  require("grug-far").open({
    prefills = {
      paths = vim.fn.expand("%"),
      search = vim.fn.expand("<cword>"),
    },
  })
end)

-- render-markdown.nvim (auto-activates on markdown ft)

-- kulala.nvim
require("kulala").setup({
  global_keymaps = true,
  global_keymaps_prefix = "<leader>e",
  kulala_keymaps_prefix = "",
  ui = {
    max_response_size = 5 * 1024 * 1024,
  },
})

-- mason.nvim (for installing LSP servers, formatters, linters)
require("mason").setup({ ui = { width = 1, height = 1 } })
