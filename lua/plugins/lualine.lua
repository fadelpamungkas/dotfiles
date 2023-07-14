return {
	"nvim-lualine/lualine.nvim",
	event = "BufReadPost",
	-- dependencies = { "arkav/lualine-lsp-progress" },
	opts = {
		options = {
			icons_enabled = false,
			theme = "auto",
			component_separators = "",
			section_separators = "",
			disabled_filetypes = { statusline = { "alpha" } },
			always_divide_middle = false,
			globalstatus = true,
			refresh = { statusline = 100 },
		},
		sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {
				{ "filename", newfile_status = true, path = 1 },
				-- { "lsp_progress" },
			},
			lualine_x = {
				{ "diagnostics" },
				{ "diff" },
				{ "location" },
				{ "progress" },
			},
			lualine_y = {},
			lualine_z = {},
		},
	},
}
