local present, alpha = pcall(require, "alpha")
if not present then
  return
end

local dashboard = require("alpha.themes.dashboard")

local function version()
  local version = vim.version()
  local nvim_version_info = "v" .. version.major .. "." .. version.minor .. "." .. version.patch
  return nvim_version_info
end

local function plugin()
  local total_plugins = #vim.tbl_keys(packer_plugins)
  return total_plugins .. " plugins"
end

local fake_button = {
  type = "group",
  val = {
    {
      type = "button",
      val = "",
      on_press = function() end,
    },
  },
  opts = {
    spacing = 0,
  },
}

local header_section = {
  type = "text",
  val = {
    "                                                                                                    ",
    "                         .^!^                                           .!~:                        ",
    "                    ^!JPB&B!.                                            !&&BPJ!:                   ",
    "                ^?P#@@@@@G.                   :       :                   !@@@@@&BY!:               ",
    "             ^JB@@@@@@@@@7                   .#~     ?P                   .&@@@@@@@@&G?:            ",
    "          .7G@@@@@@@@@@@@#!                  ?@#^   ~@@^                 .5@@@@@@@@@@@@@G7.         ",
    "        .?#@@@@@@@@@@@@@@@@BY!^.             B@@&BBB&@@Y              :~Y&@@@@@@@@@@@@@@@@#?.       ",
    "       !#@@@@@@@@@@@@@@@@@@@@@@#G5Y?!~^:..  !@@@@@@@@@@#.   ..::^!7J5B&@@@@@@@@@@@@@@@@@@@@@B!      ",
    "     .5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&##B#@@@@@@@@@@@BBBB##&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Y     ",
    "    :B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5    ",
    "   .B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@?   ",
    "   5@&#BGGPPPPPGGB&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BGGPP5PPPGBB#&#.  ",
    "   ^:..           .^!YB@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&57^.            .:^.  ",
    "                       ~G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Y.                      ",
    "                         P@@@#BGGGGB#@@@@@@@@@@@@@@@@@@@@@@@@@#BP5555PG#@@@P                        ",
    "                         :J!:.      .^!JG&@@@@@@@@@@@@@@@@#57^.        .:!5~                        ",
    "                                         :?G@@@@@@@@@@@@P!.                                         ",
    "                                            ~5@@@@@@@@5^                                            ",
    "                                              ^P@@@@G^                                              ",
    "                                                !#@?                                                ",
    "                                                                                                    ",
  },
  opts = {
    position = "center",
    hl = "Function",
  },
}

-- Set menu
-- local button_section = {
--   type = "group",
--   val = {
--     dashboard.button("n", ":enew startinsert", ":ene <BAR> startinsert <CR>"),
--     dashboard.button("c", ":e /.config/nvim/init.lua",
--       ":e $HOME/.config/nvim/init.lua | :cd %:p:h | vsplit . | wincmd k | pwd<CR>"),
--     dashboard.button("q", ":qa", ":qa<CR>"),
--   },
--   opts = {
--     position = "center",
--     spacing = 1,
--   },
-- }

-- Set footer
local footer_section = {
  type = "text",
  val = {
    version() .. " - " .. plugin(),
  },
  opts = {
    position = "center",
  },
}

vim.api.nvim_create_autocmd('User', {
  pattern = 'AlphaReady',
  desc = 'disable status and tabline for alpha',
  callback = function()
    vim.go.laststatus = 0
    vim.opt.showtabline = 0
  end,
})
vim.api.nvim_create_autocmd('BufUnload', {
  buffer = 0,
  desc = 'enable status and tabline after alpha',
  callback = function()
    vim.go.laststatus = 3
    vim.opt.showtabline = 1
  end,
})

-- Split Aplha with Explorer on startup
-- vim.cmd [[autocmd User AlphaReady vsplit .]]

-- alpha.setup(dashboard.opts)
alpha.setup({
  layout = {
    fake_button,
    { type = "padding", val = 10 },
    header_section,
    -- { type = "padding", val = 5 },
    -- button_section,
    { type = "padding", val = 2 },
    footer_section,
  },
  opts = { noautocmd = true },
})
