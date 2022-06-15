local present, nightfox = pcall(require, "nightfox")
if not present then
	return
end

-- vim.g.gruvbox_material_background = 'medium'
-- vim.g.gruvbox_material_enable_bold = 1
-- vim.g.gruvbox_material_cursor = 'auto'
-- vim.g.gruvbox_material_transparent_background = 0
-- vim.g.gruvbox_material_show_eob = 1
-- vim.g.gruvbox_material_palette = 'material'
-- -- vim.g.gruvbox_material_diagnostic_text_highlight = 1
-- -- vim.g.gruvbox_material_enable_italic = 1
-- vim.cmd [[ colorscheme gruvbox-material ]]

-- vim.g.everforest_background = 'medium'
-- vim.g.everforest_better_performace = 1
-- vim.cmd [[ colorscheme everforest ]]

nightfox.setup({
  options = {
    -- Compiled file's destination location
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled", -- Compiled file suffix
    transparent = false, -- Disable setting background
    terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
    dim_inactive = false, -- Non focused panes set to alternative background
    styles = { -- Style to be applied to different syntax groups
      comments = "italic", -- Value is any valid attr-list value `:help attr-list`
      conditionals = "NONE",
      constants = "NONE",
      functions = "NONE",
      keywords = "NONE",
      numbers = "NONE",
      operators = "NONE",
      strings = "NONE",
      types = "NONE",
      variables = "NONE",
    },
    inverse = { -- Inverse highlight for different types
      match_paren = false,
      visual = false,
      search = false,
    },
    modules = { -- List of various plugins and additional options
      -- ...
    },
  },
  palettes = {
    nightfox = {
      -- A specific style's value will be used over the `all`'s value
      -- red = "#c94f6d",
      -- comment = "#60728a",
    },
  },
  specs = {
    nightfox = {
      syntax = {
        bracket = "white.dim",
        builtin0 = "blue",
        builtin1 = "white.dim",
        builtin2 = "yellow",
        -- comment = "",
        conditional = "blue",
        -- const = "",
        -- dep = "",
        field = "white.dim",
        func = "white",
        ident = "cyan",
        keyword = "blue",
        -- number = "",
        -- operator = "",
        preproc = "red",
        -- regex = "",
        -- statement = "",
        string = "green",
        type = "white.dim",
        variable = "white.dim",
      },
    },
  },
  groups = {
  },
})

-- setup must be called before loading
vim.cmd("colorscheme nightfox")

-- vim.cmd("colorscheme meh")
