return {
	"saecki/crates.nvim",
	-- tag = "v0.3.0",
	event = "BufReadPre Cargo.toml",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = function()
		local crates = require("crates")
		local opts = { silent = true }

		vim.keymap.set("n", "<leader>ct", crates.toggle, opts)
		vim.keymap.set("n", "<leader>cr", crates.reload, opts)
		vim.keymap.set("n", "<leader>cc", crates.show_crate_popup, opts)
		vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, opts)
		vim.keymap.set("n", "<leader>cf", crates.show_features_popup, opts)
		vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, opts)

		return {
			smart_insert = true,
			insert_closing_quote = true,
			avoid_prerelease = true,
			autoload = true,
			autoupdate = true,
			autoupdate_throttle = 250,
			loading_indicator = true,
			date_format = "%Y-%m-%d",
			thousands_separator = ".",
			notification_title = "Crates",
			curl_args = { "-sL", "--retry", "1" },
			disable_invalid_feature_diagnostic = false,
			null_ls = {
				enabled = true,
				name = "Crates",
			},
			text = {
				loading = "  Loading...",
				version = "  %s",
				prerelease = "  %s",
				yanked = "  %s yanked",
				nomatch = "  Not found",
				upgrade = "  %s",
				error = "  Error fetching crate",
			},
			popup = {
				autofocus = true,
				show_version_date = true,
				keys = {
					hide = { "q", "<esc>" },
					open_url = { "<cr>" },
					select = { "<cr>" },
					select_alt = { "s" },
					toggle_feature = { "t", "<cr>" },
					copy_value = { "yy" },
					goto_item = { "gd", "K", "<C-LeftMouse>" },
					jump_forward = { "<c-i>" },
					jump_back = { "<c-o>", "<C-RightMouse>" },
				},
				text = {
					title = "# %s",
					pill_left = "",
					pill_right = "",
					created_label = "created        ",
					updated_label = "updated        ",
					downloads_label = "downloads      ",
					homepage_label = "homepage       ",
					repository_label = "repository     ",
					documentation_label = "documentation  ",
					crates_io_label = "crates.io      ",
					categories_label = "categories     ",
					keywords_label = "keywords       ",
					version = "%s",
					prerelease = "%s pre-release",
					yanked = "%s yanked",
					enabled = "* %s",
					transitive = "~ %s",
					normal_dependencies_title = "  Dependencies",
					build_dependencies_title = "  Build dependencies",
					dev_dependencies_title = "  Dev dependencies",
					optional = "? %s",
					loading = " ...",
				},
			},
			src = {
				text = {
					prerelease = " pre-release ",
					yanked = " yanked ",
				},
			},
		}
	end,
}
