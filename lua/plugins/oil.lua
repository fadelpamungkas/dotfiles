return {
	"stevearc/oil.nvim",
	keys = {
		{
			"-",
			function()
				require("oil").open()
			end,
			desc = "Oil",
		},
	},
	config = function()
		require("oil").setup({
			-- Id is automatically added at the beginning, and name at the end
			-- See :help oil-columns
			columns = {
				"permissions",
				"type",
				"size",
				-- "mtime",
			},
			-- Window-local options to use for oil buffers
			win_options = {
				wrap = false,
				signcolumn = "no",
				cursorcolumn = false,
				foldcolumn = "0",
				spell = false,
				list = false,
				conceallevel = 3,
				concealcursor = "n",
			},
			-- Restore window options to previous values when leaving an oil buffer
			restore_win_options = true,
			-- Skip the confirmation popup for simple operations
			skip_confirm_for_simple_edits = false,
			-- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
			-- options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
			-- Additionally, if it is a string that matches "action.<name>",
			-- it will use the mapping at require("oil.action").<name>
			-- Set to `false` to remove a keymap
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-o>"] = "actions.select",
				["<C-v>"] = "actions.select_vsplit",
				["<C-s>"] = "actions.select_split",
				["<C-p>"] = "actions.preview",
				["q"] = "actions.close",
				["zr"] = "actions.refresh",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["zh"] = "actions.toggle_hidden",
			},
			-- Set to false to disable all of the above keymaps
			use_default_keymaps = false,
			view_options = {
				-- Show files and directories that start with "."
				show_hidden = false,
			},
			-- Configuration for the floating window in oil.open_float
			float = {
				-- Padding around the floating window
				padding = 2,
				max_width = 0,
				max_height = 0,
				border = "rounded",
				win_options = {
					winblend = 10,
				},
			},
		})
	end,
}
