-- nvim-treesitter: parser management (highlighting/indenting are native in Neovim 0.12)
require("nvim-treesitter").setup()

-- nvim-treesitter-textobjects: config + keymaps
local ts_select = require("nvim-treesitter-textobjects.select")
local ts_move = require("nvim-treesitter-textobjects.move")

require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
    selection_modes = {
      ["@parameter.outer"] = "v",
      ["@function.outer"] = "V",
      ["@class.outer"] = "<c-v>",
    },
  },
  move = {
    set_jumps = false,
  },
})

-- Textobject select keymaps
local select_maps = {
  ["aa"] = "@parameter.outer",
  ["ia"] = "@parameter.inner",
  ["af"] = "@function.outer",
  ["if"] = "@function.inner",
  ["ac"] = "@class.outer",
  ["ic"] = "@class.inner",
  ["aB"] = "@block.outer",
  ["iB"] = "@block.inner",
  ["ai"] = "@conditional.outer",
  ["ii"] = "@conditional.inner",
  ["al"] = "@loop.outer",
  ["il"] = "@loop.inner",
}
for key, query in pairs(select_maps) do
  vim.keymap.set({ "x", "o" }, key, function()
    ts_select.select_textobject(query)
  end, { silent = true })
end

-- Textobject move keymaps
vim.keymap.set({ "n", "x", "o" }, "]]", function()
  ts_move.goto_next_start("@function.outer")
end, { silent = true })
vim.keymap.set({ "n", "x", "o" }, "][", function()
  ts_move.goto_next_end("@function.outer")
end, { silent = true })
vim.keymap.set({ "n", "x", "o" }, "[[", function()
  ts_move.goto_previous_start("@function.outer")
end, { silent = true })
vim.keymap.set({ "n", "x", "o" }, "[]", function()
  ts_move.goto_previous_end("@function.outer")
end, { silent = true })

-- Incremental selection via treesitter node hierarchy
local sel_stack = {}

local function select_node(node)
  if not node then
    return
  end
  local sr, sc, er, ec = node:range()
  vim.fn.setpos("'<", { 0, sr + 1, sc + 1, 0 })
  vim.fn.setpos("'>", { 0, er + 1, ec, 0 })
  vim.cmd("normal! gv")
end

vim.keymap.set("n", "<c-n>", function()
  local node = vim.treesitter.get_node()
  if not node then
    return
  end
  sel_stack = { node }
  select_node(node)
end, { silent = true })

vim.keymap.set("x", "<c-n>", function()
  local current = sel_stack[#sel_stack]
  if not current then
    return
  end
  local parent = current:parent()
  if parent then
    table.insert(sel_stack, parent)
    select_node(parent)
  end
end, { silent = true })

vim.keymap.set("x", "<c-p>", function()
  if #sel_stack > 1 then
    table.remove(sel_stack)
    select_node(sel_stack[#sel_stack])
  end
end, { silent = true })

-- Treesitter context
require("treesitter-context").setup({})
