local M = {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			config = true,
		},
	},
}

function M.init()
	-- vim.keymap.set("n", "<leader>xb", function()
	-- 	require("dap").toggle_breakpoint()
	-- end, { desc = "Toggle Breakpoint" })
	--
	-- vim.keymap.set("n", "<leader>xc", function()
	-- 	require("dap").continue()
	-- end, { desc = "Continue" })
	--
	-- vim.keymap.set("n", "<leader>xo", function()
	-- 	require("dap").step_over()
	-- end, { desc = "Step Over" })
	--
	-- vim.keymap.set("n", "<leader>xi", function()
	-- 	require("dap").step_into()
	-- end, { desc = "Step Into" })
	--
	-- vim.keymap.set("n", "<leader>xw", function()
	-- 	require("dap.ui.widgets").hover()
	-- end, { desc = "Widgets" })
	--
	-- vim.keymap.set("n", "<leader>xr", function()
	-- 	require("dap").repl.open()
	-- end, { desc = "Repl" })
	--
	-- vim.keymap.set("n", "<leader>xu", function()
	-- 	require("dapui").toggle({})
	-- end, { desc = "Dap UI" })
end

function M.config()
	local dap = require("dap")

	dap.configurations.rust = {
		{
			name = "Launch file",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			-- cargo = {
			-- 	args = {
			-- 		"build",
			-- 		"--bin=${workspaceFolderBasename}",
			-- 		"--package=${workspaceFolderBasename}",
			-- 	},
			-- 	filter = { "name", "${workspaceFolderBasename}" },
			-- },
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
	}

	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		-- host = "127.0.0.1",
		executable = {
			command = "codelldb",
			args = { "--port", "${port}" },
		},
	}

	local dapui = require("dapui")
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open({})
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close({})
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close({})
	end
end

-- - `DapBreakpoint` for breakpoints (default: `B`)
-- - `DapBreakpointCondition` for conditional breakpoints (default: `C`)
-- - `DapLogPoint` for log points (default: `L`)
-- - `DapStopped` to indicate where the debugee is stopped (default: `→`)
-- - `DapBreakpointRejected` to indicate breakpoints rejected by the debug
--   adapter (default: `R`)
--
-- You can customize the signs by setting them with the |sign_define()| function.
-- For example:
--
-- >
--     lua << EOF
--     vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
--     EOF
-- <

return M
