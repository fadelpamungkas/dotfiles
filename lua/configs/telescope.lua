local present, telescope = pcall(require, "telescope")
if not present then
  return
end

telescope.setup({
  defaults = {
    layout_strategy = "bottom_pane",
    file_ignore_patterns = {
      ".git",
    },
    mappings = {
      n = {
        ["q"] = require('telescope.actions').close,
        ["p"] = require('telescope.actions.layout').toggle_preview,
      },
    },
    layout_config = {
      bottom_pane = {
        height = 20,
        preview_cutoff = 120,
        prompt_position = "top"
      },
      center = {
        height = 0.4,
        preview_cutoff = 40,
        prompt_position = "top",
        width = 0.5
      },
      cursor = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8
      },
      horizontal = {
        height = 0.9,
        preview_cutoff = 120,
        prompt_position = "bottom",
        width = 0.8
      },
      vertical = {
        height = 0.9,
        preview_cutoff = 40,
        prompt_position = "bottom",
        width = 0.8
      }
    },
    initial_mode = "normal",
    prompt_title = false,
    border = true,
    borderchars = { "─", "", "", "", "", "", "", "" },
    sorting_strategy = "ascending",
    preview = {
      hide_on_startup = true,
    },
  },
  pickers = {
    find_files = {
      layout_strategy = 'bottom_pane',
    },
    git_commit = {
      theme = 'ivy',
    },
    live_grep = {
      initial_mode = "insert",
    },
    current_buffer_fuzzy_find = {
      initial_mode = "insert",
    },
    registers = {
      layout_strategy = 'bottom_pane',
    },
    oldfiles = {
      layout_strategy = 'bottom_pane',
    },
    buffers = {
      -- theme = "ivy",
      layout_strategy = 'bottom_pane',
      sort_lastuseed = true,
      mappings = {
        n = {
          ["d"] = "delete_buffer",
        }
      }
    },
  },
  extensions = {
    -- ...
  }
})
telescope.load_extension('fzf')
