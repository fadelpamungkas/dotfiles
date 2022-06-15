local present, telescope = pcall(require, "telescope")
if not present then
	return
end

telescope.setup({
  defaults = {
    layout_config = {
      vertical = { width = 0.8 }
    },
    initial_mode = "normal",
    prompt_title = false,
  },
  pickers = {
    find_files = {
      layout_strategy = 'horizontal',
    },
    git_commit = {
      theme = 'ivy',
    },
    registers = {
      layout_strategy = 'horizontal',
    },
  },
  extensions = {
    -- ...
  }
})
telescope.load_extension('fzf')
