return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "saghen/blink.cmp" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      vim.diagnostic.config({
        signs = { priority = 9999 },
        underline = false,
        update_in_insert = false,
        virtual_text = {
          source = "if_many",
          prefix = "◼︎", -- could be '●', '▎', 'x'
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          source = true,
          header = "",
        },
      })

      local lspconfig = require("lspconfig")
      local lsp_defaults = lspconfig.util.default_config
      local mason_lspconfig = require("mason-lspconfig")

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
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
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

          local function client_supports_method(client, method, bufnr)
            return client:supports_method(method, bufnr)
          end
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client
            and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
          then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            vim.keymap.set("n", "<leader>l", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end)
          end
        end,
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    event = { "BufWritePre", "BufNewFile" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "gh",
        function()
          require("conform").format({ async = true }, function(err, did_edit)
            if not err then
              local mode = vim.api.nvim_get_mode().mode
              if vim.startswith(string.lower(mode), "v") then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
              end

              if did_edit then
                vim.notify("Formatted", vim.log.levels.INFO, { title = "Conform" })
              end
            end
          end)
        end,
        mode = { "n", "v" },
      },
    },
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
        timeout_ms = 5000,
        async = true,
        quiet = false,
        lsp_fallback = true,
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascriptreact = { "eslint" },
        typescriptreact = { "eslint" },
        javascript = { "eslint" },
        typescript = { "eslint" },
        python = { "ruff", "mypy" },
        css = { "stylelint" },
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
  -- {
  --   "mfussenegger/nvim-jdtls",
  --   ft = { "java" },
  -- },
}
