local M = {
	"l3mon4d3/luasnip",
	dependencies = { "rafamadriz/friendly-snippets" },
}

function M.config()
	-- luasnip setup
	local ls = require("luasnip")
	local s = ls.snippet
	local sn = ls.snippet_node
	local isn = ls.indent_snippet_node
	local t = ls.text_node
	local i = ls.insert_node
	local f = ls.function_node
	local c = ls.choice_node
	local d = ls.dynamic_node
	local r = ls.restore_node
	local events = require("luasnip.util.events")
	local ai = require("luasnip.nodes.absolute_indexer")
	local extras = require("luasnip.extras")
	local l = extras.lambda
	local rep = extras.rep
	local p = extras.partial
	local m = extras.match
	local n = extras.nonempty
	local dl = extras.dynamic_lambda
	local fmt = require("luasnip.extras.fmt").fmt
	local fmta = require("luasnip.extras.fmt").fmta
	local conds = require("luasnip.extras.expand_conditions")
	local postfix = require("luasnip.extras.postfix").postfix
	local types = require("luasnip.util.types")
	local parse = require("luasnip.util.parser").parse_snippet
	local date = function()
		return { os.date("%Y-%m-%d") }
	end

	require("luasnip.loaders.from_vscode").lazy_load()

	-- <c-k> is my expansion key
	-- this will expand the current item or jump to the next item within the snippet.
	vim.keymap.set({ "i", "s" }, "<tab>", function()
		if ls.expand_or_jumpable() then
			ls.expand_or_jump()
		end
	end, { silent = true })

	-- <c-j> is my jump backwards key.
	-- this always moves to the previous item within the snippet
	vim.keymap.set({ "i", "s" }, "<s-tab>", function()
		if ls.jumpable(-1) then
			ls.jump(-1)
		end
	end, { silent = true })

	-- <c-l> is selecting within a list of options.
	-- This is useful for choice nodes (introduced in the forthcoming episode 2)
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
				ls.function_node(date, {}),
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
end

return M
