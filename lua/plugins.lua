return {

  -- {
  --   "wtfox/jellybeans.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("jellybeans").setup()
  --     vim.cmd.colorscheme("jellybeans")
  --   end,
  -- },
  --
  -- {
  --   "Skardyy/makurai-nvim",
  --   lazy = false,
  --   priority = 1000,
  --   -- config = function()
  --   --   require("jellybeans").setup()
  --   --   vim.cmd.colorscheme("jellybeans")
  --   -- end,
  -- },
  -- {
  --   "slugbyte/lackluster.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   init = function()
  --     local lackluster = require("lackluster")
  --
  --     lackluster.setup({
  --       -- tweak_syntax = {
  --       --   comment = lackluster.color.gray4, -- or gray5
  --       -- },
  --       tweak_background = {
  --         normal = 'none',
  --         telescope = 'none',
  --         menu = lackluster.color.gray3,
  --         popup = 'default',
  --       },
  --     })
  --
  --     -- vim.cmd.colorscheme("lackluster")
  --   end,
  -- },

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
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup({
        -- options, see Configuration section below
        -- there are no required options atm
        -- engine = 'ripgrep' is default, but 'astgrep' or 'astgrep-rules' can
        -- be specified
      });
    end
  },

  {
    "windwp/nvim-spectre",
    cmd = { "Spectre" },
    keys = {
      { "<leader>r", '<esc><cmd>lua require("spectre").open_file_search()<CR>',              mode = "v" },
      { "<leader>r", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', mode = "n" },
    },
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
      }
    },
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    opts = {
      settings = {
        save_on_toggle = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "mq",        function() require("harpoon"):list():select(1) end },
      { "mw",        function() require("harpoon"):list():select(2) end },
      { "me",        function() require("harpoon"):list():select(3) end },
      { "mr",        function() require("harpoon"):list():select(4) end },
      { "ma",        function() require("harpoon"):list():select(5) end },
      { "ms",        function() require("harpoon"):list():select(6) end },
      { "md",        function() require("harpoon"):list():select(7) end },
      { "mf",        function() require("harpoon"):list():select(8) end },
      { "<leader>h", function() require("harpoon"):list():add() end },
      {
        "<leader>H",
        function()
          local harpoon = require("harpoon")
          local opts = {
            border = "rounded",
            title = " Navigator ",
            ui_width_ratio = 0.35,
          }

          harpoon.ui:toggle_quick_menu(harpoon:list(), opts)
        end,
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
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>z", [[<cmd>lua require("persistence").load()<cr>]] },
      { "<leader>Z", [[<cmd>lua require("persistence").load({ last = true })<cr>]] },
    },
  },

  {
    'mistweaverco/kulala.nvim',
    keys = {
      { "<leader>s", function() require('kulala').run() end },
    },
    ft = "http",
    opts = {}
  },
}
