return {
	"TimUntersberger/neogit",
	cmd = "Neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
	},
	opts = {
		disable_signs = false,
		disable_hint = true,
		disable_context_highlighting = false,
		disable_commit_confirmation = true,
		disable_insert_on_commit = false,
		auto_refresh = true,
		disable_builtin_notifications = false,
		use_magit_keybindings = false,
		sort_branches = "-committerdate",
		console_timeout = 2000,
		auto_show_console = true,
		remember_settings = true,
		use_per_project_settings = true,
		ignored_settings = {},
		commit_popup = {
			kind = "split",
		},
		preview_buffer = {
			kind = "split",
		},
		kind = "tab",
		signs = {
			-- { CLOSED, OPENED }
			section = { ">", "v" },
			item = { ">", "v" },
			hunk = { ">", "v" },
		},
		integrations = {
			diffview = true,
		},
		-- Setting any section to `false` will make the section not render at all
		sections = {
			untracked = {
				folded = false,
			},
			unstaged = {
				folded = false,
			},
			staged = {
				folded = false,
			},
			stashes = {
				folded = true,
			},
			unpulled = {
				folded = true,
			},
			unmerged = {
				folded = false,
			},
			recent = {
				folded = true,
			},
		},
		-- override/add mappings
		mappings = {
			-- modify status buffer mappings
			status = {
				-- Adds a mapping with "B" as key that does the "BranchPopup" command
				-- ["B"] = "BranchPopup",
				-- Removes the default mapping of "s"
				-- ["s"] = "",
			},
		},
	},
}
