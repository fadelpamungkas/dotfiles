return {
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
			-- completion = {
			-- 	autocomplete = true,
			-- },
			view = {
				entries = "custom", -- can be "custom", "wildmenu" or "native"
				selection_order = "near_cursor",
			},
			window = {
				completion = {
					col_offset = 0,
					side_padding = 1,
				},
				documentation = {
					col_offset = 0,
					side_padding = 1,
				},
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<c-d>"] = cmp.mapping.scroll_docs(-4),
				["<c-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.close(),
				["<c-s>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.replace,
					select = true,
				}),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.replace,
					select = true,
				}),
				["<c-n>"] = cmp.mapping(function(fallback)
					if cmp.visible() == false then
						cmp.complete()
					elseif cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<c-p>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, { "i", "s" }),
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
			sources = {
				{ name = "buffer" },
			},
		})
	end,
}
