require("copilot").setup({
  copilot_node_command = "node",
  panel = { keymap = { open = "<C-CR>" } },
  filetypes = { yaml = true, markdown = true },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = "<C-s>",
      next = "<C-]>",
      prev = "<C-p>",
      dismiss = "<C-\\>",
    },
  },
})
