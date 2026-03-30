local dm = require("debugmaster")
vim.keymap.set({ "n", "v" }, "<leader>x", dm.mode.toggle, { nowait = true })
dm.plugins.cursor_hl.enabled = true

local dap = require("dap")

dap.adapters.delve = function(callback, config)
  if config.mode == "remote" and config.request == "attach" then
    callback({
      type = "server",
      host = config.host or "127.0.0.1",
      port = config.port or "38697",
    })
  else
    callback({
      type = "server",
      port = "${port}",
      executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
        detached = vim.fn.has("win32") == 0,
      },
    })
  end
end

dap.configurations.go = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = function()
      local main_file = vim.fn.getcwd() .. "/main.go"
      if vim.fn.filereadable(main_file) == 1 then
        return main_file
      else
        return vim.fn.input("Path to main.go: ", vim.fn.getcwd() .. "/", "file")
      end
    end,
  },
  {
    type = "delve",
    name = "Debug test",
    request = "launch",
    mode = "test",
    program = function()
      local test_file = vim.fn.getcwd() .. "/main_test.go"
      if vim.fn.filereadable(test_file) == 1 then
        return test_file
      else
        return vim.fn.input("Path to main_test.go: ", vim.fn.getcwd() .. "/", "file")
      end
    end,
  },
  {
    type = "delve",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
}

dap.adapters.python = function(cb, config)
  if config.request == "attach" then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or "127.0.0.1"
    cb({
      type = "server",
      port = assert(port, "`connect.port` is required for a python `attach` configuration"),
      host = host,
      options = {
        source_filetype = "python",
      },
    })
  else
    cb({
      type = "executable",
      command = "/Users/fadel.pamungkas/.local/share/nvim/mason/bin/debugpy-adapter",
      options = {
        source_filetype = "python",
      },
    })
  end
end

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = function()
      local main_file = vim.fn.getcwd() .. "/main.py"
      if vim.fn.filereadable(main_file) == 1 then
        return main_file
      else
        return vim.fn.input("Path to main.py: ", vim.fn.getcwd() .. "/", "file")
      end
    end,
    pythonPath = function()
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
        return cwd .. "/.venv/bin/python"
      elseif vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
        return cwd .. "/venv/bin/python"
      else
        return "/usr/bin/python"
      end
    end,
  },
}
