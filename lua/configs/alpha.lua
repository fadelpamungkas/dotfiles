local present, alpha = pcall(require, "alpha")
if not present then
  return
end

local dashboard = require("alpha.themes.dashboard")

local function footer()
  local total_plugins = #vim.tbl_keys(packer_plugins)
  -- local datetime = os.date("%d-%m-%Y  %H:%M:%S")
  local version = vim.version()
  local nvim_version_info = "  v" .. version.major .. "." .. version.minor .. "." .. version.patch

  return total_plugins .. " plugins" .. nvim_version_info
end

dashboard.section.header.val = {
  "                                                                                                    ",
  "                                                                                                    ",
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
  "                                                                                                    ",
  "                                                                                                    ",
}

-- Set menu
dashboard.section.buttons.val = {
  dashboard.button("n", ":enew startinsert", ":ene <BAR> startinsert <CR>"),
  dashboard.button("c", ":e /.config/nvim/init.lua",
    ":e $HOME/.config/nvim/init.lua | :cd %:p:h | vsplit . | wincmd k | pwd<CR>"),
  dashboard.button("q", ":qa", ":qa<CR>"),
}

-- Set footer
local handle = assert(io.popen('fortune -s'))
local fortune = handle:read("*all")
handle:close()
dashboard.section.footer.val = footer()
-- dashboard.section.header.opts.hl = "Title"
-- dashboard.section.buttons.opts.hl = "Debug"
-- dashboard.section.footer.opts.hl = "Title"
dashboard.config.opts.noautocmd = true
dashboard.config.opts = {
  setup = function()
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
        vim.go.laststatus = 2
        vim.opt.showtabline = 1
      end,
    })
  end,
}

-- Split Aplha with Explorer on startup
-- vim.cmd [[autocmd User AlphaReady vsplit .]]

alpha.setup(dashboard.opts)
