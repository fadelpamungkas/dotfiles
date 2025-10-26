return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      -- copilot_node_command = "/Users/fadel.pamungkas/.volta/tools/image/node/20.16.0/bin/node",
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
    },
  },

  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   version = false,
  --   build = "make",
  --   opts = {
  --     -- add any opts here
  --     -- for example
  --     -- provider = "copilot",
  --     -- copilot = {
  --     --   -- model = "claude-3.7-sonnet-thought",
  --     --   model = "claude-3.7-sonnet",
  --     --   temperature = 1,
  --     --   max_tokens = 20000,
  --     -- },
  --     provider = "ollama_qwen",
  --     providers = {
  --       ollama_qwen = {
  --         __inherited_from = "ollama",
  --         endpoint = "http://localhost:11434",
  --         model = "qwen2.5-coder:7b",
  --       	hide_in_model_selector = false,
  --         timeout = 30000,
  --       },
  --       -- ollama_gemma = {
  --       -- 	__inherited_from = "ollama",
  --       -- 	endpoint = "http://localhost:11435",
  --       -- 	model = "gemma3:4b",
  --       -- 	temperature = 0.5,
  --       -- 	hide_in_model_selector = false,
  --       -- 	timeout = 30000,
  --       -- },
  --     },
  --     -- provider = "claude",
  --     -- providers = {
  --     --   gemini = {
  --     --     model = "gemini-2.5-pro-preview-05-06",
  --     --     temperature = 0.7,
  --     --     max_tokens = 10000,
  --     --     timeout = 300000,
  --     --   },
  --     -- },
  --     behaviour = {
  --       auto_suggestions = false, -- Experimental stage
  --       auto_set_highlight_group = true,
  --       auto_set_keymaps = true,
  --       auto_apply_diff_after_generation = false,
  --       support_paste_from_clipboard = true,
  --       minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
  --       enable_token_counting = true, -- Whether to enable token counting. Default to true.
  --       auto_approve_tool_permissions = false,
  --       -- auto_approve_tool_permissions = { "bash", "replace_in_file" }, -- Auto-approve specific tools only
  --     },
  --     selector = {
  --       provider = "fzf_lua",
  --       provider_opts = {},
  --     },
  --     input = {
  --       provider = "native", -- Uses vim.ui.input
  --       provider_opts = {},
  --     },
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "ibhagwan/fzf-lua",
  --     "zbirenbaum/copilot.lua",
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- },
}
