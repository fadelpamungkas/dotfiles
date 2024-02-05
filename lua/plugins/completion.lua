return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<c-d>"] = cmp.mapping.scroll_docs(-4),
					["<c-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete()),
					["<c-y>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.replace, select = true }),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip", keyword_length = 2 },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = "buffer" } },
			})
		end,
	},
	{
		"l3mon4d3/luasnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			local ls = require("luasnip")

			ls.filetype_extend("typescriptreact", { "html" })
			require("luasnip.loaders.from_vscode").lazy_load()

			ls.config.setup({
				ext_opts = {
					[require("luasnip.util.types").choiceNode] = { active = { virt_text = { { "cnode" } } } },
					[require("luasnip.util.types").insertNode] = { active = { virt_text = { { "inode" } } } },
				},
			})

			vim.keymap.set("i", "<c-u>", require("luasnip.extras.select_choice"))
			vim.keymap.set("i", "<c-l>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end)
			vim.keymap.set({ "i", "s" }, "<tab>", function()
				if ls.expand_or_locally_jumpable() then
					ls.expand_or_jump()
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<tab>", true, true, true), "n", true)
				end
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<s-tab>", function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end, { silent = true })
		end,
	},
}
