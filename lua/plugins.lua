-- this file can be loaded by calling `lua require('plugins')` from your init.vim

vim.g.gruvbox_material_background = 'medium'
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_cursor = 'auto'
vim.g.gruvbox_material_transparent_background = 0
vim.g.gruvbox_material_show_eob = 1
vim.g.gruvbox_material_palette = 'material'
-- vim.g.gruvbox_material_diagnostic_text_highlight = 1
-- vim.g.gruvbox_material_enable_italic = 1
vim.cmd [[ colorscheme gruvbox-material ]]

-- vim.g.everforest_background = 'soft'
-- vim.g.everforest_better_performace = 1
-- vim.cmd [[ colorscheme everforest ]]

-- -- Default options
-- require('nightfox').setup({
--   options = {
--     -- Compiled file's destination location
--     compile_path = vim.fn.stdpath("cache") .. "/nightfox",
--     compile_file_suffix = "_compiled", -- Compiled file suffix
--     transparent = false, -- Disable setting background
--     terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
--     dim_inactive = false, -- Non focused panes set to alternative background
--     styles = { -- Style to be applied to different syntax groups
--       comments = "italic", -- Value is any valid attr-list value `:help attr-list`
--       conditionals = "NONE",
--       constants = "NONE",
--       functions = "NONE",
--       keywords = "NONE",
--       numbers = "NONE",
--       operators = "NONE",
--       strings = "NONE",
--       types = "NONE",
--       variables = "NONE",
--     },
--     inverse = { -- Inverse highlight for different types
--       match_paren = false,
--       visual = false,
--       search = false,
--     },
--     modules = { -- List of various plugins and additional options
--       -- ...
--     },
--   },
--   palettes = {
--     nightfox = {
--       -- A specific style's value will be used over the `all`'s value
--       -- red = "#c94f6d",
--       -- comment = "#60728a",
--     },
--   },
--   specs = {
--     nightfox = {
--       syntax = {
--         bracket = "white.dim",
--         builtin0 = "red.dim",
--         builtin1 = "",
--         builtin2 = "",
--         -- comment = "",
--         conditional = "red.dim",
--         -- const = "",
--         -- dep = "",
--         field = "white.dim",
--         func = "blue",
--         -- ident = "",
--         keyword = "red.dim",
--         -- number = "",
--         -- operator = "",
--         preproc = "red.dim",
--         -- regex = "",
--         -- statement = "",
--         string = "green",
--         type = "cyan",
--         variable = "white.dim",
--       },
--     },
--   },
--   groups = {
--   },
-- })

-- -- setup must be called before loading
-- vim.cmd("colorscheme nightfox")

require('telescope').setup({
  defaults = {
    layout_config = {
      vertical = { width = 0.8 }
    },
    initial_mode = "normal",
    prompt_title = false,
  },
  pickers = {
    find_files = {
      layout_strategy = 'horizontal',
    },
    git_commit = {
      theme = 'ivy',
    },
    registers = {
      layout_strategy = 'horizontal',
    },
  },
  extensions = {
    -- ...
  }
})
require('telescope').load_extension('fzf')

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>Telescope find_files find_command=rg,--ignore,--files<CR>', opts) -- optional: --hidden
vim.api.nvim_set_keymap('n', '<leader>g', '<cmd>Telescope live_grep<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>o', '<cmd>Telescope oldfiles<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>\'', '<cmd>Telescope registers<CR>', opts)


require 'nvim-treesitter.configs'.setup {
  -- a list of parser names, or "all"
  ensure_installed = { "go", "gomod", "gowork", "lua", "javascript", "json", "yaml", "toml" },

  -- install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- list of parsers to ignore installing (for "all")
  ignore_install = {},

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- note: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},

    -- setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- using this option may slow down your editor, and you may see some duplicate highlights.
    -- instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- you can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']n'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[n'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
}

-- mappings.
-- see `:help vim.diagnostic.*` for documentation on any of the below functions
vim.diagnostic.config({
  virtual_text = false,
  -- virtual_text = {
  --   prefix = '●', -- could be '●', '▎', 'x'
  -- },
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = false,
  float = {
    focusable = false,
    style = "minimal",
    source = "always",
    prefix = "",
  },
})

vim.cmd [[
  highlight! DiagnosticLineNrError guibg=#51202A
  highlight! DiagnosticLineNrWarn guibg=#51412A
  highlight! DiagnosticLineNrInfo guibg=#1E535D
  highlight! DiagnosticLineNrHint guibg=#1E205D

  sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=DiagnosticLineNrError
  sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=DiagnosticLineNrWarn
  sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=DiagnosticLineNrInfo
  sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=DiagnosticLineNrHint
]]

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>ds', '<cmd>lua vim.diagnostic.enable()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>dh', '<cmd>lua vim.diagnostic.disable()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>d[', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>d]', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
vim.api.nvim_set_keymap('n', '<leader>dq', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)

-- use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- show diagnostic on cursorhold
  --   vim.cmd [[autocmd! cursorhold,cursorholdi * lua vim.diagnostic.open_float(nil, {focus=false})]]
  --   vim.api.nvim_create_autocmd("cursorhold", {
  --
  --   buffer = bufnr,
  --   callback = function()
  --     local opts = {
  --       focusable = false,
  --       close_events = { "bufleave", "cursormoved", "insertenter", "focuslost" },
  --       border = 'rounded',
  --       source = 'always',
  --       prefix = ' ',
  --       scope = 'cursor',
  --     }
  --     vim.diagnostic.open_float(nil, opts)
  --   end
  -- })

  -- enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- mappings.
  -- see `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';D', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';d', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';k', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';i', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';s', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';t', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';r', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ';f', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
end

-- add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'gopls', 'rust_analyzer', 'pyright', 'sumneko_lua' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- luasnip setup
local luasnip = require 'luasnip'

vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  completion = {
    autocomplete = true
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<c-d>'] = cmp.mapping.scroll_docs(-4),
    ['<c-f>'] = cmp.mapping.scroll_docs(4),
    [';;'] = cmp.mapping.complete(),
    ['<cr>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.replace,
      select = false,
    },
    ['<tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<s-tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}


--set statusbar
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'gruvbox-material',
    component_separators = '|',
    section_separators = '',
    disabled_filetypes = {},
    always_divide_middle = false,
    globalstatus = false,
    padding = 1,
    fmt = string.lower
  },
  sections = {
    lualine_a = {
      { 'mode', fmt = function(str) return str:sub(1, 1) end } },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = {
      {
        'filename',
        file_status = true, -- Displays file status (readonly status, modified status)
        path = 3, -- 0: Just the filename
        -- 1: Relative path
        -- 2: Absolute path
        -- 3: Absolute path, with tilde as the home directory

        shorting_target = 40, -- Shortens path to leave 40 spaces in the window
        -- for other components. (terrible name, any suggestions?)
        symbols = {
          modified = '[+]', -- Text to show when the file is modified.
          readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
          unnamed = '[No Name]', -- Text to show for unnamed buffers.
        }
      }
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
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
