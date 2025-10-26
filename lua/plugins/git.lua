return {
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = { { "<leader>g", "<cmd>Neogit<cr>" } },
    opts = {
      disable_hint = true,
      disable_commit_confirmation = true,
      disable_insert_on_commit = false,
      integrations = { diffview = true },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    keys = {
      {
        "gp",
        function()
          require("gitsigns").toggle_linehl()
          require("gitsigns").toggle_deleted()
          require("gitsigns").toggle_word_diff()
        end,
      },
      {
        "gP",
        function()
          require("gitsigns").preview_hunk_inline()
        end,
      },
    },
    opts = {
      signcolumn = true,
      numhl = false,
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    opts = { use_icons = false },
  },
}
