return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "arkav/lualine-lsp-progress" },
	opts = {
		options = {
			icons_enabled = false,
			theme = "auto",
			component_separators = "",
			section_separators = "|",
			disabled_filetypes = {
				statusline = { "alpha" },
				winbar = {},
			},
			ignore_focus = {},
			always_divide_middle = false,
			globalstatus = true,
			padding = 1,
			-- fmt = string.lower,
			refresh = {
				statusline = 100,
				tabline = 1000,
				winbar = 1000,
			},
		},
		sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {
				{
					"filename",
					file_status = true, -- Displays file status (readonly status, modified status)
					newfile_status = true, -- Display new file status (new file means no write after created)
					path = 1,
					-- 0: Just the filename
					-- 1: Relative path
					-- 2: Absolute path
					-- 3: Absolute path, with tilde as the home directory

					shorting_target = 40, -- Shortens path to leave 40 spaces in the window
					symbols = {
						modified = "[+]", -- Text to show when the file is modified.
						readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
						unnamed = "[UNNAMED]", -- Text to show for unnamed buffers.
						newfile = "[NEW]", -- Text to show for new created file before first writting
					},
				},
				{
					require("lazy.status").updates,
					cond = require("lazy.status").has_updates,
					color = { fg = "#ff9e64" },
				},
				{
					"lsp_progress",
					display_components = { "lsp_client_name", { "title", "percentage", "message" } },
					separators = {
						component = " ",
						progress = " | ",
						message = { pre = "(", post = ")", commenced = "In Progress", completed = "Completed" },
						percentage = { pre = "", post = "%% " },
						title = { pre = "", post = ": " },
						lsp_client_name = { pre = "[", post = "]" },
						spinner = { pre = "", post = "" },
					},
				},
			},
			lualine_x = {
				{
					"diagnostics",
					sections = { "error", "warn", "info", "hint" },
					diagnostics_color = {
						error = "DiagnosticError", -- Changes diagnostics' error color.
						warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
						info = "DiagnosticInfo", -- Changes diagnostics' info color.
						hint = "DiagnosticHint", -- Changes diagnostics' hint color.
					},
					symbols = { error = "E", warn = "W", info = "I", hint = "H" },
					colored = false, -- Displays diagnostics status in color if set to true.
					update_in_insert = true, -- Update diagnostics in insert mode.
					always_visible = false, -- Show diagnostics even if there are none.
					fmt = string.upper,
				},
				{
					"diff",
					colored = false, -- Displays a colored diff status if set to true
					symbols = { added = "+", modified = "~", removed = "-" }, -- Changes the symbols used by the diff.
					source = function()
						local gitsigns = vim.b.gitsigns_status_dict
						if gitsigns then
							return {
								added = gitsigns.added,
								modified = gitsigns.changed,
								removed = gitsigns.removed,
							}
						end
					end,
				},
				{ "b:gitsigns_head" },
				{ "filesize", fmt = string.upper },
				{ "encoding", fmt = string.upper },
				{ "location" },
				{ "progress" },
				{
					function()
						return "▊"
					end,
				},
			},
			lualine_y = {},
			lualine_z = {},
		},
	},
}
