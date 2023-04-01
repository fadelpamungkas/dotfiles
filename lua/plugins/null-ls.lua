return {
	"jose-elias-alvarez/null-ls.nvim",
	event = "BufReadPre",
	dependencies = { "nvim-lua/plenary.nvim", "mason.nvim" },
	opts = function()
		local null_ls = require("null-ls")
		return {
			sources = {
				null_ls.builtins.formatting.prettierd,
				null_ls.builtins.formatting.gofmt,
				null_ls.builtins.formatting.goimports,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.code_actions.eslint,
				null_ls.builtins.diagnostics.eslint_d,
				null_ls.builtins.diagnostics.golangci_lint,
				null_ls.builtins.diagnostics.flake8,
				null_ls.builtins.formatting.rustfmt.with({
					extra_args = function(params)
						local Path = require("plenary.path")
						local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")

						if cargo_toml:exists() and cargo_toml:is_file() then
							for _, line in ipairs(cargo_toml:readlines()) do
								local edition = line:match([[^edition%s*=%s*%"(%d+)%"]])
								if edition then
									return { "--edition=" .. edition }
								end
							end
						end
						-- default edition when we don't find `Cargo.toml` or the `edition` in it.
						return { "--edition=2021" }
					end,
				}),
			},
		}
	end,
}
