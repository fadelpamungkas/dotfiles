return {
	"RRethy/vim-illuminate",
  enabled = false,
	event = "BufReadPost",
	config = function()
		require("illuminate").configure({ delay = 200 })
		vim.cmd([[
    hi def IlluminatedWordText guibg=#51202A gui=NONE
    hi def IlluminatedWordRead guibg=#51202A gui=NONE
    hi def IlluminatedWordWrite guibg=#51202A gui=NONE
    ]])
	end,
}
