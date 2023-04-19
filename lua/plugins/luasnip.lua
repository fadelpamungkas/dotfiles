return {
	"l3mon4d3/luasnip",
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		local ls = require("luasnip")
		local types = require("luasnip.util.types")
		local s = ls.snippet
		local t = ls.text_node
		local i = ls.insert_node

		ls.config.setup({
			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { "cnode" } },
					},
				},
				[types.insertNode] = {
					active = {
						virt_text = { { "inode" } },
					},
				},
			},
		})

		require("luasnip.loaders.from_vscode").lazy_load()

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

		vim.keymap.set("i", "<c-l>", function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end)

		vim.keymap.set("i", "<c-u>", require("luasnip.extras.select_choice"))

		ls.add_snippets(nil, {
			all = {
				ls.snippet({
					trig = "date",
					namr = "Date",
					dscr = "Date in the form of YYYY-MM-DD",
				}, {
					ls.function_node(os.date("%Y-%m-%d"), {}),
				}),
				s("dcn", {
					t('<div className="'),
					i(1),
					t('">'),
					i(2),
					t("</div>"),
				}),
			},
		})
	end,
}
