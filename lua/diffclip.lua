local M = {}

-- Smart content detection for clipboard
local function detect_filetype(content)
  -- Try to detect JSON
  if content:match("^%s*[{%[]") and content:match("[}%]]%s*$") then
    local ok = pcall(vim.fn.json_decode, content)
    if ok then
      return "json"
    end
  end

  -- Try to detect XML
  if content:match("^%s*<%?xml") or content:match("^%s*<!DOCTYPE") or content:match("^%s*<[^>]+>") then
    return "xml"
  end

  -- Try to detect common code patterns
  if content:match("function%s*[%w_]*%s*%(") or content:match("const%s+[%w_]+%s*=") then
    return "javascript"
  end

  if content:match("def%s+[%w_]+%s*%(") or content:match("import%s+[%w_.]+") then
    return "python"
  end

  if content:match("<%?php") then
    return "php"
  end

  if content:match("#include%s*<") or content:match("int%s+main%s*%(") then
    return "c"
  end

  -- Default to text
  return "text"
end

-- Enhanced diff setup with better visual feedback
local function setup_enhanced_diff()
  -- Enhanced diff options for better visualization
  vim.opt_local.diffopt:append("filler,algorithm:patience,indent-heuristic,linematch:60")

  -- Enable folding for large diffs
  vim.opt_local.foldmethod = "diff"
  vim.opt_local.foldlevel = 1
  vim.opt_local.foldenable = true

  -- Better line numbers and visual aids
  vim.opt_local.number = true
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = "yes"

  -- Enhanced diff highlighting
  vim.cmd([[
    highlight! DiffAdd guibg=#1e3a1e guifg=#90ee90
    highlight! DiffDelete guibg=#3a1e1e guifg=#ff6b6b
    highlight! DiffChange guibg=#3a3a1e guifg=#ffeb3b
    highlight! DiffText guibg=#4a4a1e guifg=#ffffff
  ]])
end

-- Quick actions for diff operations
local function setup_quick_actions()
  local diff_opts = { buffer = true, silent = true }

  -- Copy current diff to clipboard
  vim.keymap.set("n", "<leader>dy", function()
    vim.cmd("normal! V]c[c")
    vim.cmd('normal! "+y')
    vim.notify("Diff block copied to clipboard", vim.log.levels.INFO)
  end, diff_opts)

  -- Apply all clipboard changes to original
  vim.keymap.set("n", "<leader>da", function()
    local choice = vim.fn.confirm("Apply all clipboard changes to original buffer?", "&Yes\n&No", 2)
    if choice == 1 then
      vim.cmd("windo diffget")
      vim.notify("All changes applied", vim.log.levels.INFO)
    end
  end, diff_opts)

  -- Swap left and right panes
  vim.keymap.set("n", "<leader>ds", function()
    vim.cmd("wincmd r")
    vim.notify("Panes swapped", vim.log.levels.INFO)
  end, diff_opts)

  -- Focus on first difference
  vim.keymap.set("n", "<leader>df", function()
    vim.cmd("normal! gg]c")
    vim.notify("Jumped to first difference", vim.log.levels.INFO)
  end, diff_opts)

  -- Toggle word diff
  vim.keymap.set("n", "<leader>dw", function()
    local current = vim.opt_local.diffopt:get()
    local has_iwhite = vim.tbl_contains(current, "iwhite")
    if has_iwhite then
      vim.opt_local.diffopt:remove("iwhite")
      vim.notify("Word diff disabled", vim.log.levels.INFO)
    else
      vim.opt_local.diffopt:append("iwhite")
      vim.notify("Word diff enabled", vim.log.levels.INFO)
    end
  end, diff_opts)

  return diff_opts
end

-- Compare clipboard to current buffer
function M.compare_buffer()
  pcall(function()
    local clipboard_content = vim.fn.getreg("+")

    if clipboard_content == "" then
      vim.notify("Clipboard is empty", vim.log.levels.WARN)
      return
    end

    -- Enhanced content size check
    local content_size = #clipboard_content
    if content_size > 1000000 then -- 1MB limit
      local choice = vim.fn.confirm(
        "Clipboard content is very large (" .. math.floor(content_size / 1024) .. "KB). Continue?",
        "&Yes\n&No",
        2
      )
      if choice ~= 1 then
        return
      end
    end

    local original_ftype = vim.bo.filetype
    local filename = vim.fn.expand("%:t")
    if filename == "" then
      filename = "Untitled"
    end

    -- Smart filetype detection for clipboard content
    local detected_ftype = detect_filetype(clipboard_content)
    local clipboard_ftype = detected_ftype ~= "text" and detected_ftype or original_ftype

    -- Open in new tab with better layout
    vim.cmd("tabnew %")

    -- Create clipboard buffer with proper setup
    vim.cmd("vsplit") -- Vertical split for better comparison
    local clipboard_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, clipboard_buf)

    -- Set buffer options for clipboard content
    local opts_buf = {
      buftype = "nofile",
      bufhidden = "wipe",
      swapfile = false,
      filetype = clipboard_ftype, -- Use detected filetype
    }

    for opt, val in pairs(opts_buf) do
      vim.api.nvim_buf_set_option(clipboard_buf, opt, val)
    end

    -- Enhanced window titles with more info
    local size_info = content_size > 1024 and (" (" .. math.floor(content_size / 1024) .. "KB)") or ""
    vim.wo.statusline = "%#DiffDelete# Clipboard Content (" .. clipboard_ftype .. ")" .. size_info .. " %*"
    vim.cmd("normal! P")

    -- Go to original file window and set its title
    vim.cmd("wincmd l")
    vim.wo.statusline = "%#DiffAdd# " .. filename .. " (Original) %*"

    -- Enable enhanced diff mode
    vim.cmd("windo diffthis")
    setup_enhanced_diff()

    -- Setup enhanced keymaps and quick actions
    local diff_opts = setup_quick_actions()
    vim.keymap.set("n", "q", "<cmd>tabclose<CR>", diff_opts)
    vim.keymap.set("n", "]c", "]c", diff_opts) -- Next diff
    vim.keymap.set("n", "[c", "[c", diff_opts) -- Previous diff
    vim.keymap.set("n", "do", "do", diff_opts) -- Diff obtain
    vim.keymap.set("n", "dp", "dp", diff_opts) -- Diff put
    vim.keymap.set("n", "<leader>dt", "<cmd>diffthis<CR>", diff_opts) -- Toggle diff
    vim.keymap.set("n", "<leader>do", "<cmd>diffoff<CR>", diff_opts) -- Turn off diff

    -- Auto-focus on first difference
    vim.defer_fn(function()
      pcall(function()
        vim.cmd("normal! gg]c")
      end)
    end, 100)

    -- Enhanced notification with diff info
    vim.notify("Comparing " .. filename .. " with clipboard (" .. clipboard_ftype .. ")", vim.log.levels.INFO)
  end)
end

-- Compare clipboard to visual selection
function M.compare_selection()
  pcall(function()
    local clipboard_content = vim.fn.getreg("+")

    if clipboard_content == "" then
      vim.notify("Clipboard is empty", vim.log.levels.WARN)
      return
    end

    -- Enhanced content size check
    local content_size = #clipboard_content
    if content_size > 1000000 then -- 1MB limit
      local choice = vim.fn.confirm(
        "Clipboard content is very large (" .. math.floor(content_size / 1024) .. "KB). Continue?",
        "&Yes\n&No",
        2
      )
      if choice ~= 1 then
        return
      end
    end

    local original_ftype = vim.bo.filetype

    -- Save current selection to register z
    vim.cmd('normal! gv"zy')
    local selection_content = vim.fn.getreg("z")

    -- Smart filetype detection for clipboard content
    local detected_ftype = detect_filetype(clipboard_content)
    local clipboard_ftype = detected_ftype ~= "text" and detected_ftype or original_ftype

    -- Create new tab with enhanced layout
    vim.cmd("tabnew")

    -- Create selection buffer
    local selection_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, selection_buf)

    local opts_buf = {
      buftype = "nofile",
      bufhidden = "wipe",
      swapfile = false,
      filetype = original_ftype, -- Use original filetype for selection
    }
    for opt, val in pairs(opts_buf) do
      vim.api.nvim_buf_set_option(selection_buf, opt, val)
    end

    -- Enhanced window title with selection info
    local sel_lines = vim.split(selection_content, "\n")
    vim.wo.statusline = "%#DiffAdd# Selected Text (" .. #sel_lines .. " lines) %*"
    vim.cmd('normal! V"zp')

    -- Create clipboard buffer in vertical split
    vim.cmd("vsplit")
    local clipboard_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, clipboard_buf)

    -- Set clipboard buffer options with detected filetype
    local clipboard_opts = {
      buftype = "nofile",
      bufhidden = "wipe",
      swapfile = false,
      filetype = clipboard_ftype, -- Use detected filetype
    }
    for opt, val in pairs(clipboard_opts) do
      vim.api.nvim_buf_set_option(clipboard_buf, opt, val)
    end

    -- Enhanced window title with clipboard info
    local size_info = content_size > 1024 and (" (" .. math.floor(content_size / 1024) .. "KB)") or ""
    vim.wo.statusline = "%#DiffDelete# Clipboard Content (" .. clipboard_ftype .. ")" .. size_info .. " %*"
    vim.cmd("normal! VP")

    -- Enable enhanced diff mode
    vim.cmd("windo diffthis")
    setup_enhanced_diff()

    -- Setup enhanced keymaps and quick actions
    local diff_opts = setup_quick_actions()
    vim.keymap.set("n", "q", "<cmd>tabclose<CR>", diff_opts)
    vim.keymap.set("n", "]c", "]c", diff_opts) -- Next diff
    vim.keymap.set("n", "[c", "[c", diff_opts) -- Previous diff
    vim.keymap.set("n", "do", "do", diff_opts) -- Diff obtain
    vim.keymap.set("n", "dp", "dp", diff_opts) -- Diff put
    vim.keymap.set("n", "<leader>dt", "<cmd>diffthis<CR>", diff_opts) -- Toggle diff
    vim.keymap.set("n", "<leader>do", "<cmd>diffoff<CR>", diff_opts) -- Turn off diff

    -- Focus on selection buffer (left side)
    vim.cmd("wincmd h")

    -- Auto-focus on first difference
    vim.defer_fn(function()
      pcall(function()
        vim.cmd("normal! gg]c")
      end)
    end, 100)

    -- Enhanced notification with diff info
    vim.notify(
      "Comparing selection (" .. #sel_lines .. " lines) with clipboard (" .. clipboard_ftype .. ")",
      vim.log.levels.INFO
    )
  end)
end

-- Create a new scratch buffer utility
function M.new_scratch()
  pcall(function()
    vim.cmd("vsplit")
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)

    local opts = {
      buftype = "nofile",
      bufhidden = "hide",
      swapfile = false,
    }

    for opt, val in pairs(opts) do
      vim.api.nvim_buf_set_option(buf, opt, val)
    end
  end)
end

-- Setup function to initialize commands and keymaps
function M.setup()
  -- Create a new scratch buffer
  vim.api.nvim_create_user_command("Ns", function()
    M.new_scratch()
  end, { nargs = 0 })

  -- Compare clipboard to current buffer
  vim.api.nvim_create_user_command("CompareClipboard", function()
    M.compare_buffer()
  end, { nargs = 0 })

  -- Compare clipboard to visual selection
  vim.api.nvim_create_user_command("CompareClipboardSelection", function()
    M.compare_selection()
  end, {
    nargs = 0,
    range = true,
  })

  -- Keymaps for clipboard comparison
  vim.keymap.set("n", "<leader>vc", "<cmd>CompareClipboard<cr>")
  vim.keymap.set("v", "<leader>vc", "<esc><cmd>CompareClipboardSelection<cr>")
end

return M
