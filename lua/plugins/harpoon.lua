return {
	"ThePrimeagen/harpoon",
	event = "VeryLazy",
	-- enabled = false,
	config = function()
		vim.keymap.set("n", "<leader>h", require("harpoon.mark").add_file)
		vim.keymap.set("n", "<leader>H", require("harpoon.ui").toggle_quick_menu)

		vim.keymap.set("n", "<c-1>", function()
			require("harpoon.ui").nav_file(1)
		end)
		vim.keymap.set("n", "<c-2>", function()
			require("harpoon.ui").nav_file(2)
		end)
		vim.keymap.set("n", "<c-3>", function()
			require("harpoon.ui").nav_file(3)
		end)
		vim.keymap.set("n", "<c-0>", function()
			require("harpoon.ui").nav_file(4)
		end)
		vim.keymap.set("n", "<c-9>", function()
			require("harpoon.ui").nav_file(5)
		end)
		vim.keymap.set("n", "<c-8>", function()
			require("harpoon.ui").nav_file(6)
		end)
	end,
}
