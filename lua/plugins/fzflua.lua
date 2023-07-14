return {
	"ibhagwan/fzf-lua",
	cmd = "FzfLua",
	keys = {
		{ "<leader>O", "<cmd>lua require('fzf-lua').oldfiles()<CR>" },
	},
	opts = {
		-- "max-perf",
		winopts = {
			-- split = "belowright new", -- open in a top split
			border = "none",
			fullscreen = true,
			preview = {
				border = "noborder",
				delay = 0,
				scrollbar = "float",
			},
		},
    keymap = {
        -- These override the default tables completely
        -- no need to set to `false` to disable a bind
        -- delete or modify is sufficient
        builtin = {
          -- neovim `:tmap` mappings for the fzf win
          ["<F1>"]        = "toggle-help",
          ["<F2>"]        = "toggle-fullscreen",
          -- Only valid with the 'builtin' previewer
          ["<F3>"]        = "toggle-preview-wrap",
          ["<ctrl-;>"]        = "toggle-preview",
          -- Rotate preview clockwise/counter-clockwise
          ["<F5>"]        = "toggle-preview-ccw",
          ["<F6>"]        = "toggle-preview-cw",
          ["<S-down>"]    = "preview-page-down",
          ["<S-up>"]      = "preview-page-up",
          ["<S-left>"]    = "preview-page-reset",
        },
        -- fzf = {
        --   -- fzf '--bind=' options
        --   ["ctrl-z"]      = "abort",
        --   ["ctrl-u"]      = "unix-line-discard",
        --   ["ctrl-f"]      = "half-page-down",
        --   ["ctrl-b"]      = "half-page-up",
        --   ["ctrl-a"]      = "beginning-of-line",
        --   ["ctrl-e"]      = "end-of-line",
        --   ["alt-a"]       = "toggle-all",
        --   -- Only valid with fzf previewers (bat/cat/git/etc)
        --   ["f3"]          = "toggle-preview-wrap",
        --   ["f4"]          = "toggle-preview",
        --   ["shift-down"]  = "preview-page-down",
        --   ["shift-up"]    = "preview-page-up",
        -- },
      },
	},
	-- config = function()
	-- 	local actions = require("fzf-lua.actions")
	-- 	require("fzf-lua").setup({
	-- 		winopts = {
	-- 			-- height = 0.3, -- window height
	-- 			-- width = 0.80, -- window width
	-- 			-- row = 0.35, -- window row position (0=top, 1=bottom)
	-- 			-- col = 0.50, -- window col position (0=left, 1=right)
	-- 			fullscreen = true, -- start fullscreen?
	-- 			preview = {
	-- 				border = "noborder", -- border|noborder, applies only to
	-- 				delay = 0, -- delay(ms) displaying the preview
	-- 				-- scrollbar = "border", -- `false` or string:'float|border'
	-- 			},
	-- 		},
	-- 	})
	-- end,
}
