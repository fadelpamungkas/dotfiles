-- luasnip setup
local luasnip = require 'luasnip'
local date = function() return { os.date('%Y-%m-%d') } end

luasnip.add_snippets(nil, {
  all = {
    luasnip.snippet({
      trig = "date",
      namr = "Date",
      dscr = "Date in the form of YYYY-MM-DD",
    }, {
      luasnip.function_node(date, {}),
    }),
  },
})
