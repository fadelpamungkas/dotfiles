return {
  {
    "miroshQa/debugmaster.nvim",
    dependencies = { "mfussenegger/nvim-dap", },
    keys = { "<leader>x" },
    config = function()
      local dm = require("debugmaster")
      vim.keymap.set({ "n", "v" }, "<leader>x", dm.mode.toggle, { nowait = true })
      dm.plugins.cursor_hl.enabled = true
      -- If you want to disable debug mode in addition to leader+d using the Escape key:
      -- vim.keymap.set("n", "<Esc>", dm.mode.disable)
      -- This might be unwanted if you already use Esc for ":noh"
      -- vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

      local dap = require("dap")
      -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
      dap.adapters.delve = function(callback, config)
        if config.mode == 'remote' and config.request == 'attach' then
          callback({
            type = 'server',
            host = config.host or '127.0.0.1',
            port = config.port or '38697'
          })
        else
          callback({
            type = 'server',
            port = '${port}',
            executable = {
              command = 'dlv',
              args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
              detached = vim.fn.has("win32") == 0,
            }
          })
        end
      end

      -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          -- program = "${file}"
          program = function()
            -- check if in cwd has main.go, if not ask for the path
            local main_file = vim.fn.getcwd() .. '/main.go'
            if vim.fn.filereadable(main_file) == 1 then
              return main_file
            else
              return vim.fn.input('Path to main.go: ', vim.fn.getcwd() .. '/', 'file')
            end
          end,
        },
        {
          type = "delve",
          name = "Debug test", -- configuration for debugging test files
          request = "launch",
          mode = "test",
          -- program = "${file}"
          program = function()
            -- check if in cwd has main_test.go, if not ask for the path
            local test_file = vim.fn.getcwd() .. '/main_test.go'
            if vim.fn.filereadable(test_file) == 1 then
              return test_file
            else
              return vim.fn.input('Path to main_test.go: ', vim.fn.getcwd() .. '/', 'file')
            end
          end,
        },
        -- works with go.mod packages and sub packages
        {
          type = "delve",
          name = "Debug test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}"
        }
      }

      dap.adapters.python = function(cb, config)
        if config.request == 'attach' then
          ---@diagnostic disable-next-line: undefined-field
          local port = (config.connect or config).port
          ---@diagnostic disable-next-line: undefined-field
          local host = (config.connect or config).host or '127.0.0.1'
          cb({
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
              source_filetype = 'python',
            },
          })
        else
          cb({
            type = 'executable',
            command = '/Users/fadel.pamungkas/.local/share/nvim/mason/bin/debugpy-adapter',
            -- args = { '-m', 'debugpy.adapter' },
            options = {
              source_filetype = 'python',
            },
          })
        end
      end
      dap.configurations.python = {
        {
          -- The first three options are required by nvim-dap
          type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = 'launch',
          name = "Launch file",

          -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

          -- program = "${file}", -- This configuration will launch the current file if used.
          -- check if in cwd has main.py, if not ask for the path
          program = function()
            local main_file = vim.fn.getcwd() .. '/main.py'
            if vim.fn.filereadable(main_file) == 1 then
              return main_file
            else
              return vim.fn.input('Path to main.py: ', vim.fn.getcwd() .. '/', 'file')
            end
          end,
          pythonPath = function()
            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            elseif vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            else
              return '/usr/bin/python'
            end
          end,
        },
      }
    end
  }
}
-- return {
--   "mfussenegger/nvim-dap",
--   dependencies = {
--     { "rcarriga/nvim-dap-ui", config = true },
--     { "nvim-neotest/nvim-nio" },
--     { 'leoluz/nvim-dap-go',   ft = 'go' },
--   },
--   config = function()
--     local dap = require("dap")
--     local dapui = require("dapui")
--
--     require("dap-go").setup()
--
--     -- dap.adapters.delve = {
--     --   type = "server",
--     --   port = "${port}",
--     --   executable = {
--     --     command = "dlv",
--     --     args = { "dap", "-l", "127.0.0.1:${port}" },
--     --   },
--     -- }
--     --
--     -- dap.configurations.go = {
--     --   {
--     --     type = "delve",
--     --     name = "Debug",
--     --     request = "launch",
--     --     envFile = "${workspaceFolder}/.env",
--     --     program = "${workspaceFolder}/cmd/main.go",
--     --     cwd = "${workspaceFolder}",
--     --   },
--     --   {
--     --     type = "delve",
--     --     name = "Debug test", -- configuration for debugging test files
--     --     request = "launch",
--     --     mode = "test",
--     --     program = "${file}",
--     --   },
--     --   -- works with go.mod packages and sub packages
--     --   {
--     --     type = "delve",
--     --     name = "Debug test (go.mod)",
--     --     request = "launch",
--     --     mode = "test",
--     --     program = "./${relativeFileDirname}",
--     --   },
--     -- }
--     --
--     -- dap.adapters.codelldb = {
--     --   type = "server",
--     --   port = "${port}",
--     --   executable = {
--     --     command = "codelldb",
--     --     args = { "--port", "${port}" },
--     --   },
--     -- }
--     --
--     -- dap.configurations.rust = {
--     --   {
--     --     name = "Launch file",
--     --     type = "codelldb",
--     --     request = "launch",
--     --     program = function()
--     --       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
--     --     end,
--     --     cwd = "${workspaceFolder}",
--     --     stopOnEntry = false,
--     --   },
--     -- }
--
--     dap.listeners.after.event_initialized["dapui_config"] = function()
--       dapui.open({})
--     end
--     dap.listeners.before.event_terminated["dapui_config"] = function()
--       dapui.close({})
--     end
--     dap.listeners.before.event_exited["dapui_config"] = function()
--       dapui.close({})
--     end
--   end,
-- }
