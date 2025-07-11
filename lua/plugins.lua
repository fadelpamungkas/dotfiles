return {

  { "nvim-lua/plenary.nvim" },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "BufReadPost",
    opts = {},
  },

  {
    "Wansmer/treesj",
    keys = { { "gJ", "<cmd>TSJToggle<cr>" } },
    opts = { use_default_keymaps = false },
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = { ui = { width = 1, height = 1 } },
  },

  {
    "MagicDuck/grug-far.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("grug-far").open({
            paths = { vim.fn.expand("%") },
          })
        end,
        mode = "v",
      },
      {
        "<leader>r",
        function()
          require("grug-far").open({
            prefills = { search = vim.fn.expand("<cword>") },
          })
        end,
        mode = "n",
      },
    },
    config = function()
      require("grug-far").setup({
        -- options, see Configuration section below
        -- there are no required options atm
        -- engine = 'ripgrep' is default, but 'astgrep' or 'astgrep-rules' can
        -- be specified
      })
    end,
  },

  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    keys = { { "<leader>d", "<cmd>Trouble diagnostics toggle<cr>" } },
    opts = {
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
    },
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = { { "-", "<cmd>lua require('oil').open()<CR>" } },
    opts = {
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
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "s", function() require("flash").jump() end,       mode = { "n", "x", "o" } },
      { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" } },
      { "r", function() require("flash").remote() end,     mode = "o" },
    },
    opts = {
      -- jump = { autojump = true },
      modes = { char = { jump_labels = true, multi_line = false } },
    },
  },

  {
    "mistweaverco/kulala.nvim",
    keys = {
      {
        "<leader>s",
        function()
          require("kulala").run()
        end,
      },
    },
    ft = "http",
    opts = {},
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
  },
}
