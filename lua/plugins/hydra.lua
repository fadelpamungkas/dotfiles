return {
  {
    "nvimtools/hydra.nvim",
    enabled = false,
    -- keys = { "<leader>x" },
    config = function()
      if vim.g.__debug_config then
        vim.notify("Avoiding advanced keycommands and modes as we are in debug mode")
        return
      end
      local Hydra = require("hydra")
      Hydra.setup({
        config = {
          hint = {
            type = "window",
            float_opts = {
              border = "rounded"
            }
          }
        }
      })
      local cmd = require("hydra.keymap-util").cmd
      local lsp_hydra, dap_hydra, repl_hydra, test_hydra = nil, nil, nil, nil

      local mode_hydras = {}

      local hydra_hint_func = function(mode)
        return function()
          return string.format('[%s]', vim.g.__miversen_extended_mode == mode and "x" or "")
        end
      end

      -- TODO: For some reason, we actually have to quit the mode from within the mode
      -- Hydra:exit doesn't seem to properly close out the hydra...
      local hydra_disable_function = function(mode, is_exiting)
        if mode == vim.g.__miversen_extended_mode then
          vim.g.__miversen_extended_mode = nil
        end

        if mode_hydras[mode] and mode_hydras[mode].exit and not is_exiting then
          mode_hydras[mode]:close()
        end
      end

      local hydra_enable_function = function(mode)
        vim.g.__miversen_extended_mode = mode
        if not mode then
          for mode_name, _ in pairs(mode_hydras) do
            hydra_disable_function(mode_name)
          end
          return
        end
        if mode_hydras[mode] and mode_hydras[mode].activate then
          mode_hydras[mode]:activate()
        end
      end


      local hydra_toggle_function = function(mode)
        return function()
          if vim.g.__miversen_extended_mode == mode or not mode then
            hydra_disable_function(mode)
          else
            hydra_enable_function(mode)
          end
        end
      end
      lsp_hydra = Hydra({
        name = "LSP Mode",
        mode = { "n", "v" },
        hint = [[
^                 LSP
^
-------------Token actions-------------
_r_: Rename current token
_a_: Code Actions
_s_: Show Definitions
_e_: Hover Help
_n_: Show References of current token
_o_: Show implementation of current token
_D_: Show declerations of current token
^
-------------Buffer actions------------
_d_: Show buffer diagnostics
_w_: Show workspace diagnostics
_f_: Format Buffer
^
---------------------------------------
_<Esc>_: Close this window
_?_: Toggle this help
_q_: Quit Mode
]],
        config = {
          color = "pink",
          invoke_on_body = true,
          hint = {
            type = "window",
            position = "middle-right",
            float_opts = {
              border = "rounded"
            },
            hide_on_load = true
          },
          on_exit = function()
            hydra_disable_function('lsp', true)
          end
        },
        heads = {
          {
            "a",
            function()
              vim.lsp.buf.code_action()
            end,
            {
              desc = "Code actions for current token",
              silent = true,
              exit = false,
              private = true
            }
          },
          {
            "s",
            cmd("Glance definitions"),
            {
              desc = "Definitions for current token",
              silent = true,
              exit = false,
              private = true
            }
          },
          {
            "r",
            function()
              vim.lsp.buf.rename()
            end,
            {
              desc = "Rename the current token",
              silent = true,
              exit = false,
              private = true
            }
          },
          {
            "d",
            cmd("Glance document_diagnostics"),
            {
              desc = "Show current diagnostics for buffer",
              silent = true,
              exit = false,
              private = true,
            }
          },
          {
            "w",
            cmd("Glace workspace_diagnostics"),
            {
              desc = "Show workspace diagnostics",
              silent = true,
              exit = true,
              private = true
            }
          },
          {
            "f",
            function()
              vim.lsp.buf.format({ async = true })
            end,
            {
              desc = "Format current buffer",
              silent = true,
              exit = false,
              private = true
            }
          },
          {
            "n",
            cmd("Glance references"),
            {
              desc = "Show references to token",
              silent = true,
              exit = false,
              private = true
            }
          },
          {
            "e",
            function()
              require("pretty_hover").hover()
            end,
            {
              desc = "Show Hover Doc",
              silent = true,
              exit = false,
              private = true
            }
          },
          {
            "D",
            cmd("Glance type_definitions"),
            {
              desc = "Shows current token declerations",
              silent = true,
              exit = false,
              private = true
            }
          },
          {
            "o",
            cmd("Glance implementations"),
            {
              desc = "Show Implementations of current token",
              silent = true,
              exit = false,
              private = true
            }
          },
          {
            "?",
            function()
              if lsp_hydra.hint.win then
                lsp_hydra.hint:close()
              else
                lsp_hydra.hint:show()
              end
            end,
            {
              private = true,
              silent = true
            }
          },
          {
            "<Esc>",
            function()
              if lsp_hydra.hint.win then
                lsp_hydra.hint:close()
              end
            end,
            {
              private = true,
              silent = true
            }
          },
          {
            "q",
            nil,
            {
              exit = true,
              silent = true
            }
          }
        }
      })
      dap_hydra = Hydra({
        name = "DAP",
        mode = { "n", "v" },
        config = {
          color = "pink",
          -- invoke_on_body = true,
          hint = {
            type = "window",
            position = "middle-right",
            float_opts = {
              border = "rounded"
            },
            hide_on_load = true,
          },
          on_exit = function()
            hydra_disable_function('dap', true)
          end
        },
        hint = [[
^              DAP
^
-------------Setup--------------
_t_: Toggle UI
_L_: Launch DAP Server
_S_: Stop Debugger
_r_: Open DAP REPL
^
-----------Navigation-----------
_k_: Step **OUT** of code block
_o_: Step **OVER** code block
_j_: Step **INTO** code block
^
-----------Breakpoint-----------
_d_: Toggle Breakpoint
_D_: Toggle Conditional Breakpoint
_c_: Continue after breakpoint
^
--------------------------------
_<Esc>_: Close this window
_?_: Toggle this help
_q_: Quit Mode
]],

        heads = {
          {
            "t",
            function()
              require("dapui").toggle()
            end,
            {
              desc = "Toggles Dap UI",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "d",
            function()
              require("dap").toggle_breakpoint()
            end,
            {
              desc = "Set Breakpoint",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "D",
            function()
              local callback = function(output)
                if output then
                  require("dap").set_breakpoint(output)
                end
              end
              vim.ui.input(
                {
                  prompt = "Condition: ",
                },
                callback
              )
            end,
            {
              desc = "Set Conditional Breakpoint",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "c",
            function()
              require("dap").continue()
            end,
            {
              desc = "Continue from breakpoint",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "S",
            function()
              local dap = require("dap")
              dap.terminate(
                {},
                {
                  terminateDebugee = true
                },
                function()
                  dap.close()
                end
              )
            end,
            {
              desc = "Stop Debugger",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "k",
            function()
              require("dap").step_out()
            end,
            {
              desc = "Step out of code block",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "o",
            function()
              require("dap").step_over()
            end,
            {
              desc = "Step **over** code block",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "j",
            function()
              require("dap").step_into()
            end,
            {
              desc = "Step **into** code block",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "L",
            function()
              local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
              local dap = require("dap")
              if filetype == '' then filetype = 'nil' end
              if dap and dap.launch_server and dap.launch_server[filetype] then
                dap.launch_server[filetype]()
              else
                vim.notify(string.format("No DAP Launch server configured for filetype %s", filetype),
                  vim.log.levels.WARN)
              end
            end,
            {
              desc = "Launch DAP server",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "r",
            function()
              require("dap").repl.open()
            end,
            {
              desc = "Open DAP REPL",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "?",
            function()
              if dap_hydra.hint.win then
                dap_hydra.hint:close()
              else
                dap_hydra.hint:show()
              end
            end,
            {
              private = true,
              silent = true
            }
          },
          {
            "<Esc>",
            function()
              if dap_hydra.hint.win then
                dap_hydra.hint:close()
              end
            end,
            {
              private = true,
              silent = true
            }
          },
          {
            "q",
            nil,
            {
              exit = true,
              silent = true
            }
          }
        }
      })

      test_hydra = Hydra({
        name = "Testing",
        mode = { "n", "v" },
        config = {
          color = "pink",
          invoke_on_body = true,
          hint = {
            type = "window",
            position = "middle-right",
            float_opts = {
              border = "rounded"
            },
            hide_on_load = true,
          },
          on_exit = function()
            hydra_disable_function('test', true)
          end
        },
        hint = [[
^          Testing
^
-------------------------------
_t_: Toggle unit test UI
^
_r_: Run unit tests for this file
_a_: Run all unit tests
_d_: Run unit tests in DAP mode
^
_l_: Re-run last unit test(s)
^
_s_: Stop all tests
^
-------------------------------
_<Esc>_: Close this window
_?_: Toggle this help
_q_: Quit Mode
]],

        heads = {
          {
            "t",
            function()
              require("neotest").output_panel.toggle()
            end,
            {
              desc = "Toggles unit test UI",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "r",
            function()
              require("neotest").run.run(vim.fn.expand("%"))
            end,
            {
              desc = "Run unit tests for file",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "a",
            function()
              require("neotest").run.run()
            end,
            {
              desc = "Run all unit tests",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "d",
            function()
              require("neotest").run.run({ strategy = "dap" })
            end,
            {
              desc = "Run unit tests in DAP mode",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "l",
            function()
              require("neotest").run.run_last()
            end,
            {
              desc = "Rerun previous unit test",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "s",
            function()
              require("neotest").run.stop()
            end,
            {
              desc = "Stop unit tests",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "?",
            function()
              if test_hydra.hint.win then
                test_hydra.hint:close()
              else
                test_hydra.hint:show()
              end
            end,
            {
              private = true,
              silent = true
            }
          },
          {
            "<Esc>",
            function()
              if test_hydra.hint.win then
                test_hydra.hint:close()
              end
            end,
            {
              private = true,
              silent = true
            }
          },
          {
            "q",
            nil,
            {
              exit = true,
              silent = true
            }
          }
        }
      })

      repl_hydra = Hydra({
        name = "REPL",
        mode = { "n", "v" },
        config = {
          color = "pink",
          invoke_on_body = true,
          hint = {
            type = "window",
            position = "middle-right",
            float_opts = {
              border = "rounded"
            },
            hide_on_load = true,
          },
          on_exit = function()
            hydra_disable_function('repl', true)
          end
        },
        hint = [[
^          REPL
^
--------------------------------
_<C-S>_: Send current file to REPL
_r_: Restart REPL
^
-------------------------------
_<Esc>_: Close this window
_?_: Toggle this help
_q_: Quit Mode
]],

        heads = {
          {
            "<C-s>",
            function()
              vim.cmd("%SnipRun")
            end,
            {
              desc = "Writes current file to repl",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "r",
            function()
              require("sniprun").reset()
            end,
            {
              desc = "Resets repl",
              exit = false,
              private = true,
              silent = true
            }
          },
          {
            "?",
            function()
              if test_hydra.hint.win then
                test_hydra.hint:close()
              else
                test_hydra.hint:show()
              end
            end,
            {
              private = true,
              silent = true
            }
          },
          {
            "<Esc>",
            function()
              if test_hydra.hint.win then
                test_hydra.hint:close()
              end
            end,
            {
              private = true,
              silent = true
            }
          },
          {
            "q",
            nil,
            {
              exit = true,
              silent = true
            }
          }
        }
      })
      Hydra({
        name = "Mode",
        mode = { "n", "v" },
        hint = [[
^ ^ Extended Mode
^
^ _d_ %{dap_mode} DAP
^ _r_ %{repl_mode} REPL
^ _l_ %{lsp_mode} LSP
^ _t_ %{test_mode} Testing
^ _c_ Clear mode
^
^ _q_ Quit
        ]],
        config = {
          hint = {
            type = "window",
            position = "middle",
            float_opts = {
              border = "rounded"
            },
            -- hide_on_load = true,
            funcs = {
              dap_mode = hydra_hint_func("dap"),
              repl_mode = hydra_hint_func("repl"),
              lsp_mode = hydra_hint_func("lsp"),
              test_mode = hydra_hint_func('test'),
            }
          },
          color = "blue",
          invoke_on_body = true,
        },
        body = "<leader>x",
        heads = {
          {
            "d",
            hydra_toggle_function("dap"),
            {
              private = true,
              on_key = false,
            }
          },
          {
            "r",
            hydra_toggle_function("repl"),
            {
              private = true,
              on_key = false,
            }
          },
          {
            "l",
            hydra_toggle_function("lsp"),
            {
              private = true,
              on_key = false
            }
          },
          {
            "t",
            hydra_toggle_function("test"),
            {
              private = true,
              on_key = false
            }
          },
          {
            "c",
            hydra_toggle_function(),
            {
              private = true,
              on_key = false
            }
          },
          {
            "q",
            nil,
            {
              exit = true
            }
          },
        }
      })
      mode_hydras = {
        lsp = lsp_hydra,
        dap = dap_hydra,
        test = test_hydra,
        repl = repl_hydra,
      }

      ---- Non mode hydra stuffs
      Hydra({
        name = "Quick/Common Commands",
        mode = { "n" },
        hint = [[
^                                Quick/Common Commands
^
^_f_: Show Filesystem        _t_: Show Terminal (float)       _x_: Open Quickfix
^_s_: Buffer Fuzzy Search    _o_: Open Horizontal Terminal    _p_: Open Vertical Terminal
^_h?_: Show Help Tags        _c?_: Show Vim Commands          _m?_: Show Man Pages
^_l_: Open Location List
^
^                                _q_/_<Esc>_: Exit Hydra
]],
        config = {
          color = 'teal',
          invoke_on_body = true,
          hint = {
            type = "window",
            position = "bottom",
            float_opts = {
              border = 'rounded',
            },
            show_name = true,
          }
        },
        body = "t",
        heads = {
          {
            "f",
            cmd 'Neotree filesystem reveal right',
            {
              desc = "Opens Neotree File Explorer",
              silent = true
            }
          },
          {
            "h?",
            cmd "Telescope help_tags",
            {
              desc = "Open Help Tags",
              silent = true
            }
          },
          {
            "c?",
            cmd "Telescope commands",
            {
              desc = "Open Available Telescope Commands",
              silent = true
            }
          },
          {
            "s",
            cmd "Telescope current_buffer_fuzzy_find skip_empty_lines=true",
            {
              desc = "Fuzzy find in current buffer",
              silent = true
            }
          },
          {
            "m?",
            cmd "Telescope man_pages",
            {
              desc = "Opens Man Pages",
              silent = true
            }
          },
          {
            "x",
            cmd "TroubleToggle quickfix",
            {
              desc = "Opens Quickfix",
              silent = true
            }
          },
          {
            "l",
            cmd "TroubleToggle loclist",
            {
              desc = "Opens Location List",
              silent = true
            }
          },
          {
            "t",
            cmd "CFloatTerm",
            {
              desc = "Floating Term",
              silent = true
            }
          },
          {
            "o",
            cmd "CSplitTerm horizontal",
            {
              desc = "Horizontal Term",
              silent = true
            }
          },
          {
            "p",
            cmd "CSplitTerm vertical",
            {
              desc = "Vertical Term",
              silent = true
            }
          },
          {
            "q",
            nil,
            {
              desc = "quit",
              exit = true,
              nowait = true
            }
          },
          {
            "<Esc>",
            nil,
            {
              desc = "quit",
              exit = true,
              nowait = true
            }
          }
        }
      })
    end
  },
  --  {
  --    "anuvyklack/hydra.nvim",
  --    keys = { "<leader>g", "<leader>x" },
  --    config = function()
  --      local hydra = require("hydra")
  --      local gitsigns = require("gitsigns")
  --      local dap = require("dap")
  --
  --      hydra({
  --        name = "Git",
  --        config = {
  --          buffer = bufnr,
  --          color = "pink",
  --          invoke_on_body = true,
  --          on_enter = function()
  --            vim.cmd("mkview")
  --            vim.cmd("silent! %foldopen!")
  --            vim.bo.modifiable = false
  --            -- gitsigns.toggle_signs(true)
  --            gitsigns.toggle_linehl(true)
  --          end,
  --          on_exit = function()
  --            local cursor_pos = vim.api.nvim_win_get_cursor(0)
  --            vim.cmd("loadview")
  --            vim.api.nvim_win_set_cursor(0, cursor_pos)
  --            vim.cmd("normal zv")
  --            -- gitsigns.toggle_signs(false)
  --            gitsigns.toggle_linehl(false)
  --            gitsigns.toggle_deleted(false)
  --          end,
  --        },
  --        mode = { "n", "x" },
  --        body = "<leader>g",
  --        heads = {
  --          {
  --            "J",
  --            function()
  --              if vim.wo.diff then
  --                return "]c"
  --              end
  --              vim.schedule(function()
  --                gitsigns.next_hunk()
  --              end)
  --              return "<Ignore>"
  --            end,
  --            { expr = true },
  --          },
  --          {
  --            "K",
  --            function()
  --              if vim.wo.diff then
  --                return "[c"
  --              end
  --              vim.schedule(function()
  --                gitsigns.prev_hunk()
  --              end)
  --              return "<Ignore>"
  --            end,
  --            { expr = true, desc = "jump" },
  --          },
  --
  --          { "p", gitsigns.preview_hunk,          { desc = "preview" } },
  --          {
  --            "R",
  --            function()
  --              vim.bo.modifiable = true
  --              gitsigns.reset_buffer()
  --              vim.bo.modifiable = false
  --            end,
  --          },
  --          {
  --            "r",
  --            function()
  --              vim.bo.modifiable = true
  --              gitsigns.reset_hunk()
  --              vim.bo.modifiable = false
  --            end,
  --            { desc = "reset" },
  --          },
  --          { "u", gitsigns.undo_stage_hunk,       { desc = "undo" } },
  --          { "d", gitsigns.toggle_deleted,        { nowait = true, desc = "deleted" } },
  --          { "S", gitsigns.stage_buffer },
  --          { "s", "<cmd>Gitsigns stage_hunk<CR>", { silent = true, desc = "stage" } },
  --          {
  --            "B",
  --            function()
  --              gitsigns.blame_line({ full = true })
  --            end,
  --          },
  --          { "b",     gitsigns.blame_line,     { desc = "blame" } },
  --          { "/",     gitsigns.show,           { exit = true, desc = "base" } },
  --          { "D",     "<Cmd>DiffviewOpen<CR>", { exit = true, desc = "diff" } },
  --          { "n",     "<Cmd>Neogit<CR>",       { exit = true, desc = "Neogit" } },
  --          { "q",     nil,                     { exit = true, nowait = true } },
  --          { "<Esc>", nil,                     { exit = true, nowait = true } },
  --        },
  --      })
  --
  --      hydra({
  --        name = "Dap",
  --        hint = [[
  -- _n_: step over   _s_: Start/Continue   _b_: Breakpoint       _u_: Toggle UI
  -- _i_: step into   _x_: Disconnect       _K_: Hover Variables  _r_: Toggle Repl
  -- _o_: step out    _c_: to cursor        _E_: Evaluate         _C_: Close UI
  -- ^
  -- ^ ^              _X_: Quit             _q_: exit
  -- 	]],
  --        config = {
  --          buffer = bufnr,
  --          color = "pink",
  --          invoke_on_body = true,
  --          hint = {
  --            position = "bottom",
  --            border = "rounded",
  --          },
  --        },
  --        mode = { "n", "x" },
  --        body = "<leader>x",
  --        heads = {
  --          { "C", "<cmd>lua require('dapui').close()<cr>:DapVirtualTextForceRefresh<cr>", { silent = true } },
  --          { "u", "<cmd>lua require('dapui').toggle()<cr>",                               { silent = true } },
  --          { "E", "<cmd>lua require('dapui').eval()<cr>",                                 { silent = true } },
  --          { "K", "<cmd>lua require('dap.ui.widgets').hover()<cr>",                       { silent = true } },
  --          { "X", dap.close,                                                              { silent = true } },
  --          { "b", dap.toggle_breakpoint,                                                  { silent = true } },
  --          { "c", dap.run_to_cursor,                                                      { silent = true } },
  --          { "i", dap.step_into,                                                          { silent = true } },
  --          { "n", dap.step_over,                                                          { silent = true } },
  --          { "o", dap.step_out,                                                           { silent = true } },
  --          { "r", dap.repl.toggle,                                                        { silent = true } },
  --          { "s", dap.continue,                                                           { silent = true } },
  --          { "t", "<cmd>lua require('dap-go').debug_test()<cr>",                          { silent = true } },
  --          { "T", "<cmd>lua require('dap-go').debug_last()<cr>",                          { silent = true } },
  --          {
  --            "x",
  --            "<cmd>lua require'dap'.disconnect({ terminateDebuggee = false })<cr>",
  --            { exit = true, silent = true },
  --          },
  --          { "q", nil, { exit = true, nowait = true } },
  --        },
  --      })
  --    end,
  --  }
}
