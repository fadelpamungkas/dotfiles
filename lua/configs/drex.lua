local present, drex = pcall(require, "drex.config")
if not present then
  return
end

drex.configure {
  icons = {
    file_default = "o",
    dir_open = "v",
    dir_closed = ">",
    link = "~",
    others = "*",
  },
  colored_icons = true,
  hide_cursor = true,
  hijack_netrw = false,
  sorting = function(a, b)
    local aname, atype = a[1], a[2]
    local bname, btype = b[1], b[2]

    local aisdir = atype == 'directory'
    local bisdir = btype == 'directory'

    if aisdir ~= bisdir then
      return aisdir
    end

    return aname < bname
  end,
  drawer = {
    default_width = 30,
    window_picker = {
      enabled = true,
      labels = 'abcdefghijklmnopqrstuvwxyz',
    },
  },
  disable_default_keybindings = false,
  keybindings = {
    ['n'] = {
      ['v']             = 'V',
      ['l']             = '<cmd>lua require("drex").expand_element()<CR>',
      ['h']             = '<cmd>lua require("drex").collapse_directory()<CR>',
      ['<right>']       = '<cmd>lua require("drex").expand_element()<CR>',
      ['<left>']        = '<cmd>lua require("drex").collapse_directory()<CR>',
      ['<2-LeftMouse>'] = '<LeftMouse><cmd>lua require("drex").expand_element()<CR>',
      ['<RightMouse>']  = '<LeftMouse><cmd>lua require("drex").collapse_directory()<CR>',
      ['<C-v>']         = '<cmd>lua require("drex").open_file("vs")<CR>',
      ['<C-x>']         = '<cmd>lua require("drex").open_file("sp")<CR>',
      ['<C-t>']         = '<cmd>lua require("drex").open_file("tabnew")<CR>',
      -- ['<C-l>'] = '<cmd>lua require("drex").open_directory()<CR>',
      -- ['<C-h>'] = '<cmd>lua require("drex").open_parent_directory()<CR>',
      ['<F5>']          = '<cmd>lua require("drex").reload_directory()<CR>',
      ['gj']            = '<cmd>lua require("drex.jump").jump_to_next_sibling()<CR>',
      ['gk']            = '<cmd>lua require("drex.jump").jump_to_prev_sibling()<CR>',
      ['gh']            = '<cmd>lua require("drex.jump").jump_to_parent()<CR>',
      ['s']             = '<cmd>lua require("drex.actions").stats()<CR>',
      ['a']             = '<cmd>lua require("drex.actions").create()<CR>',
      ['d']             = '<cmd>lua require("drex.actions").delete("line")<CR>',
      ['D']             = '<cmd>lua require("drex.actions").delete("clipboard")<CR>',
      ['p']             = '<cmd>lua require("drex.actions").copy_and_paste()<CR>',
      ['P']             = '<cmd>lua require("drex.actions").cut_and_move()<CR>',
      ['r']             = '<cmd>lua require("drex.actions").rename()<CR>',
      ['R']             = '<cmd>lua require("drex.actions").multi_rename("clipboard")<CR>',
      ['M']             = '<cmd>DrexMark<CR>',
      ['u']             = '<cmd>DrexUnmark<CR>',
      ['m']             = '<cmd>DrexToggle<CR>',
      ['cc']            = '<cmd>lua require("drex.actions").clear_clipboard()<CR>',
      ['cs']            = '<cmd>lua require("drex.actions").open_clipboard_window()<CR>',
      ['y']             = '<cmd>lua require("drex.actions").copy_element_name()<CR>',
      ['Y']             = '<cmd>lua require("drex.actions").copy_element_relative_path()<CR>',
      ['<C-y>']         = '<cmd>lua require("drex.actions").copy_element_absolute_path()<CR>',
    },
    ['v'] = {
      ['d'] = ':lua require("drex.actions").delete("visual")<CR>',
      ['r'] = ':lua require("drex.actions").multi_rename("visual")<CR>',
      ['M'] = ':DrexMark<CR>',
      ['u'] = ':DrexUnmark<CR>',
      ['m'] = ':DrexToggle<CR>',
      ['y'] = ':lua require("drex.actions").copy_element_name(true)<CR>',
      ['Y'] = ':lua require("drex.actions").copy_element_relative_path(true)<CR>',
      ['<C-y>'] = ':lua require("drex.actions").copy_element_absolute_path(true)<CR>',
    }
  },
  -- auto expand when Drex open
  on_enter = function()
    local row = 1
    while true do
      local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
      if require('drex.utils').is_closed_directory(line) then
        require('drex').expand_element(0, row)
      end
      row = row + 1

      if row > vim.fn.line('$') then
        break
      end
    end
  end,
  on_leave = nil,
}
