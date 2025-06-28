return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- { "hrsh7th/cmp-nvim-lsp" },
      { 'saghen/blink.cmp' },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      vim.diagnostic.config({
        signs = { priority = 9999 },
        underline = false,
        update_in_insert = false,
        virtual_text = {
          -- severity = { max = "WARN" },
          prefix = "◼︎", -- could be '●', '▎', 'x'
        },
        -- virtual_lines = {
        --   current_line = true,
        --   -- severity = { min = "INFO", max = "ERROR" },
        --   -- severity = { min = "ERROR" },
        -- },
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          source = true,
          header = "",
        },
      })

      -- local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
      -- for type, _ in pairs(signs) do
      -- 	local hl = "DiagnosticSign" .. type
      -- 	vim.fn.sign_define(hl, { texthl = hl, numhl = hl, linehl = hl })
      -- end

      local lspconfig = require("lspconfig")
      local lsp_defaults = lspconfig.util.default_config
      local mason_lspconfig = require("mason-lspconfig")

      -- lsp_defaults.capabilities =
      --     vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

      local servers = {
        lua_ls = {
          Lua = {
            hint = { enable = true },
            diagnostics = { globals = { "vim" } },
          },
        },
        gopls = {
          gopls = {
            gofumpt = true,
            usePlaceholders = true,
            completeUnimported = true,
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        -- ruff = {},
        -- ruff_lsp = {
        --   settings = {
        --     ruff = {
        --       format = {
        --         sortImports = true,
        --       },
        --     },
        --   },
        -- },
        -- eslint = {},
        -- clangd = {},
        -- pyright = {},
        -- rust_analyzer = {}, -- handled by rust-tools.nvim
        -- tsserver = {},
        -- tailwindcss = {},
      }
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local opts = { noremap = true, silent = true, buffer = event.buf }

          vim.keymap.set("n", "<leader>D", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gi", "<cmd>Trouble lsp_implementations toggle<cr>", opts)
          vim.keymap.set("n", "gr", "<cmd>Trouble lsp_references toggle<cr>", opts)
          vim.keymap.set("n", "gL", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", opts)
          vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.keymap.set('n', '<leader>l', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, opts)
          end
        end,
      })

      mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })
      mason_lspconfig.setup_handlers({
        function(server_name)
          if server_name ~= "jdtls" then
            lspconfig[server_name].setup({
              capabilities = lsp_defaults.capabilities,
            })
          else
            lspconfig[server_name].setup({
              capabilities = require("blink.cmp").get_lsp_capabilities(),
              settings = servers[server_name]
            })
          end
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufNewFile" },
    cmd = { "ConformInfo" },
    keys = { { "gh", "<cmd>Format<cr>", mode = { "n", "v" } } },
    opts = {
      formatters_by_ft = {
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        markdown = { "prettier" },
        python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
        html = { "prettier" },
        yaml = { "prettier" },
        json = { "prettier" },
        css = { "prettier" },
        lua = { "stylua" },
        go = { "goimports", "gofumpt", "golines" },
      },
      format = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_fallback = true,
      },
      -- format_on_save = {},
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      -- local utils = require("core.utils")

      lint.linters_by_ft = {
        javascriptreact = { "eslint" },
        typescriptreact = { "eslint" },
        javascript = { "eslint" },
        typescript = { "eslint" },
        python = { "ruff", "mypy" },
        css = { "stylelint" },
        -- lua = { "luacheck" },
        go = { "golangcilint" },
      }

      lint.linters.luacheck.args = {
        globals = {
          "vim",
        },
      }

      local augroup = vim.api.nvim_create_augroup("CodeLinting", {})

      vim.api.nvim_create_autocmd({
        "BufReadPost",
        "InsertLeave",
        "TextChanged",
        "FocusGained",
      }, {
        pattern = "*",
        group = augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
