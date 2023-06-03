---@diagnostic disable: param-type-mismatch
return {
	"stevearc/oil.nvim",
	cmd = "Oil",
	keys = {
		{
			"-",
			function()
				require("oil").open()
			end,
		},
	},
	init = function()
		if vim.fn.argc() == 1 then
			local stat = vim.loop.fs_stat(vim.fn.argv(0))
			local adapter = string.match(vim.fn.argv(0), "^([%l-]*)://")
			if (stat and stat.type == "directory") or adapter == "oil-ssh" then
				require("lazy").load({ plugins = { "oil.nvim" } })
			end
		end
	end,
	opts = {
		columns = {
			"permissions",
			"type",
			"size",
		},
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
		use_default_keymaps = false,
		view_options = {
			show_hidden = true,
		},
	},
}
