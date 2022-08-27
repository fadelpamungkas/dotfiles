local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local colors = {
  bg = '#39506d',
  fg = '#cdcecf',
}

local custom = {
  normal = {
    a = { bg = colors.bg, fg = colors.fg, gui = 'bold' },
    b = { bg = colors.bg, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg }
  },
  insert = {
    a = { bg = colors.bg, fg = colors.fg, gui = 'bold' },
    b = { bg = colors.bg, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg }
  },
  visual = {
    a = { bg = colors.bg, fg = colors.fg, gui = 'bold' },
    b = { bg = colors.bg, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg }
  },
  replace = {
    a = { bg = colors.bg, fg = colors.fg, gui = 'bold' },
    b = { bg = colors.bg, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg }
  },
  command = {
    a = { bg = colors.bg, fg = colors.fg, gui = 'bold' },
    b = { bg = colors.bg, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg }
  },
  inactive = {
    a = { bg = colors.bg, fg = colors.fg, gui = 'bold' },
    b = { bg = colors.bg, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg }
  }
}

--set statusbar
lualine.setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = '',
    section_separators = '|',
    disabled_filetypes = {},
    always_divide_middle = false,
    globalstatus = true,
    padding = 1,
    fmt = string.lower
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_z = {},
    lualine_y = {
      {
        'diagnostics',

        -- Table of diagnostic sources, available sources are:
        --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
        -- or a function that returns a table as such:
        --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }

        -- Displays diagnostics for the defined severity types
        sections = { 'error', 'warn', 'info', 'hint' },

        diagnostics_color = {
          -- Same values as the general color option can be used here.
          error = 'DiagnosticError', -- Changes diagnostics' error color.
          warn  = 'DiagnosticWarn', -- Changes diagnostics' warn color.
          info  = 'DiagnosticInfo', -- Changes diagnostics' info color.
          hint  = 'DiagnosticHint', -- Changes diagnostics' hint color.
        },
        symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' },
        colored = true, -- Displays diagnostics status in color if set to true.
        update_in_insert = true, -- Update diagnostics in insert mode.
        always_visible = false, -- Show diagnostics even if there are none.
        fmt = string.upper,
      },
      {
        'diff',
        colored = false, -- Displays a colored diff status if set to true
        diff_color = {
          -- Same color values as the general color option can be used here.
          added    = 'DiffAdd', -- Changes the diff's added color
          modified = 'DiffChange', -- Changes the diff's modified color
          removed  = 'DiffDelete', -- Changes the diff's removed color you
        },
        symbols = { added = '+', modified = '~', removed = '-' }, -- Changes the symbols used by the diff.
        source = nil, -- A function that works as a data source for diff.
        -- It must return a table as such:
        --   { added = add_count, modified = modified_count, removed = removed_count }
        -- or nil on failure. count <= 0 won't be displayed.
      },
      { 'branch' },
      {
        'filename',
        file_status = true, -- Displays file status (readonly status, modified status)
        newfile_status = false, -- Display new file status (new file means no write after created)
        path = 0, -- 0: Just the filename
        -- 1: Relative path
        -- 2: Absolute path
        -- 3: Absolute path, with tilde as the home directory

        shorting_target = 40, -- Shortens path to leave 40 spaces in the window
        -- for other components. (terrible name, any suggestions?)
        symbols = {
          modified = '[+]', -- Text to show when the file is modified.
          readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
          unnamed = '[No Name]', -- Text to show for unnamed buffers.
          newfile = '[New]', -- Text to show for new created file before first writting
        }
      },
      { 'progress' },
    },
    -- lualine_a = { { 'mode', fmt = function(str) return str:sub(1, 1) end } },
    -- lualine_b = {},
    -- lualine_c = {
    --   {
    --     'branch'
    --   },
    --   {
    --     'diff'
    --   },
    --   {
    --     'diagnostics', fmt = string.upper
    --   },
    --   {
    --     'filename',
    --     file_status = true, -- Displays file status (readonly status, modified status)
    --     path = 3, -- 0: Just the filename
    --     -- 1: Relative path
    --     -- 2: Absolute path
    --     -- 3: Absolute path, with tilde as the home directory
    --
    --     shorting_target = 40, -- Shortens path to leave 40 spaces in the window
    --     -- for other components. (terrible name, any suggestions?)
    --     symbols = {
    --       modified = '[+]', -- Text to show when the file is modified.
    --       readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
    --       unnamed = '[No Name]', -- Text to show for unnamed buffers.
    --     }
    --   },
    --   {
    --     'filesize'
    --   },
    --   {
    --     function()
    --       local msg = 'LSP == nil'
    --       local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    --       local clients = vim.lsp.get_active_clients()
    --       if next(clients) == nil then
    --         return msg
    --       end
    --       for _, client in ipairs(clients) do
    --         local filetypes = client.config.filetypes
    --         if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
    --           return client.name
    --         end
    --       end
    --       return msg
    --     end,
    --   }
    -- },
    -- lualine_x = { 'encoding', 'fileformat', 'filetype', 'progress' },
    -- lualine_y = {},
    -- lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
