-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- show cursor line only in active window
local cursorGrp = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  pattern = "*",
  command = "set cursorline",
  group = cursorGrp,
})
vim.api.nvim_create_autocmd(
  { "InsertEnter", "WinLeave" },
  { pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- TODO: comment
vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
  callback = function()
    vim.cmd([[
        hi link TodoComment WarningMsg
        match TodoComment /\(TODO\|FIXME\|FIX\|ISSUE\|NOTE\|INFO\|WARN\|PERF\|TEST\):/
        ]])
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "qf",
    "help",
    "man",
    "vim",
    "lspinfo",
    "spectre_panel",
    "tsplayground",
    "PlenaryTestPopup",
    "rest_nvim_results",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- auto toggle highlight search
local ns = vim.api.nvim_create_namespace("toggle_hlsearch")

local function toggle_hlsearch(char)
  if vim.fn.mode() == "n" then
    local keys = { "<CR>", "n", "N", "*", "#", "?", "/" }
    local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))

    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end

vim.on_key(toggle_hlsearch, ns)

-- Create a new scratch buffer
vim.api.nvim_create_user_command("Ns", function()
  vim.cmd([[
		execute 'vsplit | enew'
		setlocal buftype=nofile
		setlocal bufhidden=hide
		setlocal noswapfile
	]])
end, { nargs = 0 })

-- Compare clipboard to current buffer
vim.api.nvim_create_user_command("CompareClipboard", function()
  local ftype = vim.api.nvim_eval("&filetype") -- original filetype
  vim.cmd([[
		tabnew %
		Ns
		normal! P
		windo diffthis
	]])
  vim.cmd("set filetype=" .. ftype)
  vim.cmd("nnoremap <silent> <buffer> q <cmd>tabclose<CR>")
end, { nargs = 0 })

-- Assign it to a keymap
vim.keymap.set("n", "<leader>vc", "<cmd>CompareClipboard<cr>")

-- Compare clipboard to visual selection
vim.api.nvim_create_user_command("CompareClipboardSelection", function()
  vim.cmd([[
		" yank visual selection to z register
		normal! gv"zy
		" open new tab, set options to prevent save prompt when closing
		execute 'tabnew | setlocal buftype=nofile bufhidden=hide noswapfile'
		" paste z register into new buffer
		normal! V"zp
		Ns
		normal! Vp
		windo diffthis
	]])
  vim.cmd("nnoremap <silent> <buffer> q <cmd>tabclose<CR>")
end, {
  nargs = 0,
  range = true,
})

-- Assign it to a keymap
vim.keymap.set("v", "<leader>vc", "<esc><cmd>CompareClipboardSelection<cr>")

function _G.toggle_quickfix()
  local windows = vim.api.nvim_list_wins()

  for _, win in pairs(windows) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "quickfix" then
        vim.cmd("cclose")
        return
      end
    end
  end

  vim.cmd("botright copen")
end

vim.keymap.set("n", "<leader>q", ":lua toggle_quickfix()<CR>", { noremap = true, silent = true })

-- diagnostic virtual text/lines toggle
-- local og_virt_text
-- local og_virt_line
-- vim.api.nvim_create_autocmd({ 'CursorMoved', 'DiagnosticChanged' }, {
--   group = vim.api.nvim_create_augroup('diagnostic_only_virtlines', {}),
--   callback = function()
--     if og_virt_line == nil then
--       og_virt_line = vim.diagnostic.config().virtual_lines
--     end
--
--     -- ignore if virtual_lines.current_line is disabled
--     if not (og_virt_line and og_virt_line.current_line) then
--       if og_virt_text then
--         vim.diagnostic.config({ virtual_text = og_virt_text })
--         og_virt_text = nil
--       end
--       return
--     end
--
--     if og_virt_text == nil then
--       og_virt_text = vim.diagnostic.config().virtual_text
--     end
--
--     local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
--
--     if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = lnum })) then
--       vim.diagnostic.config({ virtual_text = og_virt_text })
--     else
--       vim.diagnostic.config({ virtual_text = false })
--     end
--   end
-- })
--
-- vim.api.nvim_create_autocmd('ModeChanged', {
--   group = vim.api.nvim_create_augroup('diagnostic_redraw', {}),
--   callback = function()
--     pcall(vim.diagnostic.show)
--   end
-- })

-- curl
-- local response_buf = nil
--
-- vim.api.nvim_create_user_command("ExecuteCurl", function(opts)
-- 	local start_line, end_line
--
-- 	if opts.range == 0 then
-- 		start_line = 0
-- 		end_line = -1
-- 	else
-- 		start_line = opts.line1 - 1
-- 		end_line = opts.line2
-- 	end
--
-- 	local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
-- 	local curl_command = table.concat(lines, " "):gsub("%s+", " ")
--
-- 	local result = ""
-- 	local job_id = vim.fn.jobstart(curl_command, {
-- 		on_stdout = function(_, data)
-- 			result = result .. table.concat(data, "\n")
-- 		end,
-- 		on_exit = function()
-- 			vim.schedule(function()
-- 				result = result:gsub("\r\n", "\n")
--
-- 				if response_buf and vim.api.nvim_buf_is_valid(response_buf) then
-- 					vim.api.nvim_buf_set_lines(response_buf, 0, -1, false, {})
-- 				else
-- 					response_buf = vim.api.nvim_create_buf(false, true)
-- 					vim.api.nvim_buf_set_option(response_buf, "buftype", "nofile")
-- 					vim.api.nvim_buf_set_option(response_buf, "bufhidden", "hide")
-- 					vim.api.nvim_buf_set_option(response_buf, "swapfile", false)
-- 					vim.api.nvim_buf_set_name(response_buf, "Curl Response")
-- 				end
--
-- 				vim.api.nvim_buf_set_lines(response_buf, 0, -1, false, vim.split(result, "\n"))
--
-- 				local win_id = vim.fn.bufwinid(response_buf)
-- 				if win_id == -1 then
-- 					vim.cmd("vsplit")
-- 					vim.api.nvim_win_set_buf(0, response_buf)
-- 				else
-- 					vim.api.nvim_set_current_win(win_id)
-- 					end
--
-- 				if result:match("^%s*{") or result:match("^%s*%\[") then
-- 					vim.api.nvim_buf_set_option(response_buf, "filetype", "json")
-- 				else
-- 					vim.api.nvim_buf_set_option(response_buf, "filetype", "http")
-- 				end
--
-- 				vim.api.nvim_buf_set_keymap(response_buf, "n", "q", ":hide<CR>", { noremap = true, silent = true })
-- 			end)
-- 		end,
-- 	})
--
-- 	if job_id == 0 then
-- 		print("Failed to start job")
-- 	elif job_id == -1 then
-- 		print("Invalid arguments")
-- 	else
-- 		print("Executing curl command...")
-- 	end
-- end, { range = true })
--
-- vim.keymap.set("v", "<leader>xc", ":ExecuteCurl<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>xc", "vap:ExecuteCurl<CR>", { noremap = true, silent = true })

-- local M = {}
-- local NS = vim.api.nvim_create_namespace('find_and_replace')
--
-- ---@param line string
-- ---@return string, string, string
-- local function parse_line(line)
--   return string.match(line, '^(.*):(%d*):(.*)$')
-- end
--
-- M.find_and_replace = function()
--   local input = vim.fn.input('Find and replace: ')
--   local paths = vim.fn.input('In files(comma separated): ', '', 'file')
--
--   local cmd = { 'rg', '--hidden', '--glob', '!.git/*', '--line-number', input }
--   if paths ~= '' then
--     -- manually expand paths with globbing
--     for _, path in ipairs(vim.split(paths, ',')) do
--       if string.find(path, '%*') then
--         local expanded = vim.fn.expand(path, false, true)
--         ---@diagnostic disable-next-line: param-type-mismatch
--         vim.list_extend(cmd, expanded)
--       else
--         table.insert(cmd, path)
--       end
--     end
--   end
--
--   vim.system(cmd, { text = true }, function(obj)
--     if vim.trim(obj.stdout) == '' then
--       return vim.schedule(function()
--         vim.notify('No results found', vim.log.levels.INFO)
--       end)
--     end
--     assert(obj.code == 0, 'Rg command failed; stderr:\n' .. obj.stderr)
--
--     vim.schedule(function()
--       local lines_str = vim.trim(obj.stdout or '')
--       local initial_lines = vim.split(lines_str, '\n')
--       ---@type {file: string, line_number: string, text: string}[]
--       local matches = vim.tbl_map(
--       ---@param line string
--       ---@return {file: string, line_number: string, text: string}
--         function(line)
--           local file, line_number, text = parse_line(line)
--           return {
--             file = file,
--             line_number = line_number,
--             text = text,
--           }
--         end,
--         initial_lines
--       )
--       local tmp_file = vim.fn.tempname()
--
--       vim.fn.writefile(
--       ---@param m {file: string, line_number: string, text: string}
--       ---@return string
--         vim.tbl_map(function(m)
--           return m.text
--         end, matches),
--         tmp_file
--       )
--
--       vim.cmd.tabnew(tmp_file)
--       local buf = vim.api.nvim_get_current_buf()
--
--       vim.api.nvim_set_option_value('wrap', false, { scope = 'local' })
--
--       for i, m in ipairs(matches) do
--         local lnum = i - 1         -- 0 based
--
--         vim.api.nvim_buf_set_extmark(buf, NS, lnum, 0, {
--           virt_lines = {
--             {
--
--               { m.file,        'Directory' },
--               { ':',           'Comment' },
--               { m.line_number, 'Directory' },
--             },
--           },
--           virt_lines_above = true,
--           hl_mode = 'combine',
--         })
--       end
--
--       vim.keymap.set('n', 'gf', function()
--         local i = vim.api.nvim_win_get_cursor(0)[1]
--         local file, line_number = matches[i].file, matches[i].line_number
--         vim.cmd(string.format('edit %s | :%s | normal zz', file, line_number))
--       end, { buffer = buf, desc = 'open file on line' })
--
--       vim.api.nvim_create_autocmd('BufWritePost', {
--         desc = 'If lines are changed, apply changes to files',
--         buffer = buf,
--         callback = function()
--           local new_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
--
--           local function undo(msg)
--             vim.notify(msg, vim.log.levels.ERROR)
--             vim.api.nvim_buf_set_lines(buf, 0, -1, false, initial_lines)
--           end
--
--           if #new_lines ~= #initial_lines then
--             return undo('Number of lines changed, undoing changes')
--           end
--
--           local changes_count = 0
--
--           for i, new_text in ipairs(new_lines) do
--             if new_text ~= matches[i].text then
--               local file, line_number = matches[i].file, matches[i].line_number
--               local init_file, init_lnum = parse_line(initial_lines[i])
--
--               if file == init_file and line_number == init_lnum then
--                 ---@type string[]
--                 local og_lines = vim.fn.readfile(file)
--
--                 og_lines[tonumber(line_number)] = new_text
--
--                 vim.fn.writefile(og_lines, file)
--
--                 matches[i].text = new_text
--
--                 changes_count = changes_count + 1
--               else
--                 return undo('Do not change file paths or line numbers, aborting')
--               end
--             end
--           end
--
--           vim.schedule(function()
--             vim.print('Changes made: ' .. changes_count)
--           end)
--         end,
--       })
--
--       -- by default the first virtual line is not shown, we need to scroll up for it to be displayed
--       local command = vim.api.nvim_replace_termcodes('<C-u>', true, false, true)
--       vim.api.nvim_feedkeys(command, 'nt', false)
--     end)
--   end)
-- end
--
-- vim.api.nvim_create_user_command('FindAndReplace', M.find_and_replace, {
--   nargs = 0,
--   desc = 'Find and replace string with rg',
-- })

vim.api.nvim_create_user_command("Ask", function(opts)
  local prompt = opts.fargs[1]
  if not prompt or prompt == "" then
    print("Prompt cannot be empty.")
    return
  end

  local command = "gemini -p " .. vim.fn.shellescape(prompt)
  local result = vim.fn.system(command)
  if vim.v.shell_error ~= 0 then
    print("Command failed with error: " .. vim.v.shell_error)
    return
  end

  vim.cmd("vsplit | enew")
  vim.api.nvim_buf_set_option(0, "buftype", "nofile")
  vim.api.nvim_buf_set_option(0, "bufhidden", "hide")
  vim.api.nvim_buf_set_option(0, "swapfile", false)
  vim.api.nvim_buf_set_name(0, "Gemini Result")

  local lines = vim.split(result, "\n")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end, { nargs = 1, complete = "file" })
