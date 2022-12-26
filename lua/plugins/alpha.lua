local M = {
	"goolord/alpha-nvim",
	lazy = false,
  enable = true,
}

function M.config()
	local alpha = require("alpha")
	local nvim_version = vim.version()
	local version = "v" .. nvim_version.major .. "." .. nvim_version.minor .. "." .. nvim_version.patch
	local plugins = require("lazy").stats().count .. " plugins"

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

	local header_section2 = {
		type = "text",
		val = {
			"Preconfigured NVIM " .. version .. " - " .. plugins,
		},
		opts = {
			position = "center",
			hl = "Function",
		},
	}

	local top_body = {
		type = "text",
		val = {
			"Nvim is open source and freely distributable",
			"          https://neovim.io/#chat",
		},
		opts = {
			position = "center",
		},
	}

	local mid_body = {
		type = "text",
		val = {
			"type :help nvim             if you are new!",
			"type :checkhealth           to optimize Nvim",
			"type :q                     to exit",
			"type :help                  for help",
		},
		opts = {
			position = "center",
		},
	}

	local bot_body = {
		type = "text",
		val = {
			"       Become a registered Vim user!",
			"type :help register         for information",
		},
		opts = {
			position = "center",
		},
	}

	local body_section = {
		type = "group",
		val = {
			top_body,
			{ type = "padding", val = 1 },
			mid_body,
			{ type = "padding", val = 1 },
			bot_body,
		},
		opts = {
			position = "center",
		},
	}

	-- alpha.setup(dashboard.opts)
	alpha.setup({
		layout = {
			fake_button,
			{ type = "padding", val = 20 },
			header_section2,
			-- { type = "padding", val = 5 },
			-- button_section,
			{ type = "padding", val = 1 },
			body_section,
		},
		opts = { noautocmd = true },
	})
end

return M
