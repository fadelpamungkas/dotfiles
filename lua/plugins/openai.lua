return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			panel = { keymap = { open = "<C-CR>" } },
			filetypes = { yaml = true, markdown = true },
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<C-s>",
					next = "<C-]>",
					prev = "<C-[>",
					dismiss = "<C-\\>",
				},
			},
		},
	},

	{
		"robitx/gp.nvim",
		keys = {
			{ "<leader>C", "<cmd>GpChatFinder<cr>" },
			{ "<leader>c", "<cmd>GpChatNew tabnew<cr>" },
            { "<leader>c", ":'<,'>GpChatNew tabnew<cr>", mode = "v" },
		},
		event = "BufReadPre",
		config = function()
			require("gp").setup({
				openai_api_key = { "bw", "get", "password", "OPENAI_API_KEY" },
				chat_free_cursor = true,
				hooks = {
					InspectPlugin = function(plugin, params)
						local bufnr = vim.api.nvim_create_buf(false, true)
						local copy = vim.deepcopy(plugin)
						local key = copy.config.openai_api_key
						copy.config.openai_api_key = key:sub(1, 3) .. string.rep("*", #key - 6) .. key:sub(-3)
						local plugin_info = string.format("Plugin structure:\n%s", vim.inspect(copy))
						local params_info = string.format("Command params:\n%s", vim.inspect(params))
						local lines = vim.split(plugin_info .. "\n" .. params_info, "\n")
						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
						vim.api.nvim_win_set_buf(0, bufnr)
					end,

					-- GpImplement rewrites the provided selection/range based on comments in it
					Implement = function(gp, params)
						local template = "Having following from {{filename}}:\n\n"
							.. "```{{filetype}}\n{{selection}}\n```\n\n"
							.. "Please rewrite this according to the contained instructions."
							.. "\n\nRespond exclusively with the snippet that should replace the selection above."

						local agent = gp.get_command_agent()
						gp.info("Implementing selection with agent: " .. agent.name)

						gp.Prompt(
							params,
							gp.Target.rewrite,
							nil, -- command will run directly without any prompting for user input
							agent.model,
							template,
							agent.system_prompt
						)
					end,

					-- your own functions can go here, see README for more examples like
					-- :GpExplain, :GpUnitTests.., :GpTranslator etc.

					-- -- example of making :%GpChatNew a dedicated command which
					-- -- opens new chat with the entire current buffer as a context
					-- BufferChatNew = function(gp, _)
					-- 	-- call GpChatNew command in range mode on whole buffer
					-- 	vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
					-- end,

					-- -- example of adding command which opens new chat dedicated for translation
					-- Translator = function(gp, params)
					-- 	local agent = gp.get_command_agent()
					-- 	local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
					-- 	gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
					-- end,

					UnitTests = function(gp, params)
						local template = "I have the following code from {{filename}}:\n\n"
							.. "```{{filetype}}\n{{selection}}\n```\n\n"
							.. "Please respond by writing table driven unit tests for the code above."
						local agent = gp.get_command_agent()
						gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
					end,

					Explain = function(gp, params)
						local template = "I have the following code from {{filename}}:\n\n"
							.. "```{{filetype}}\n{{selection}}\n```\n\n"
							.. "Please respond by explaining the code above."
						local agent = gp.get_chat_agent()
						gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
					end,

					Enhance = function(gp, params)
						local template = "I have the following code from {{filename}}:\n\n"
							.. "```{{filetype}}\n{{selection}}\n```\n\n"
							.. "Please respond by suggesting enhancements, improvements, or adherence to best practices for the code above. Consider aspects such as performance optimization, code readability, security, error handling, modularity, and testing strategies."
						local agent = gp.get_command_agent()
						gp.Prompt(params, gp.Target.vnew, nil, agent.model, template, agent.system_prompt)
					end,
				},
			})
		end,
	},
	-- {
	-- 	"jackMort/ChatGPT.nvim",
	-- 	event = "BufReadPre",
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-telescope/telescope.nvim",
	-- 	},
	-- 	config = function()
	-- 		require("chatgpt").setup({
	-- 			api_key_cmd = "bw get password OPENAI_API_KEY",
	-- 			yank_register = "+",
	-- 			edit_with_instructions = {
	-- 				diff = false,
	-- 				keymaps = {
	-- 					close = "<C-c>",
	-- 					accept = "<C-y>",
	-- 					toggle_diff = "<C-d>",
	-- 					toggle_settings = "<C-o>",
	-- 					toggle_help = "<C-h>",
	-- 					cycle_windows = "<Tab>",
	-- 					use_output_as_input = "<C-i>",
	-- 				},
	-- 			},
	-- 			chat = {
	-- 				loading_text = "Loading, please wait ...",
	-- 				question_sign = "", -- 🙂
	-- 				answer_sign = "ﮧ", -- 🤖
	-- 				border_left_sign = "",
	-- 				border_right_sign = "",
	-- 				max_line_length = 120,
	-- 				sessions_window = {
	-- 					active_sign = "  ",
	-- 					inactive_sign = "  ",
	-- 					current_line_sign = "",
	-- 					border = {
	-- 						style = "rounded",
	-- 						text = {
	-- 							top = " Sessions ",
	-- 						},
	-- 					},
	-- 					win_options = {
	-- 						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
	-- 					},
	-- 				},
	-- 				keymaps = {
	-- 					close = "<C-c>",
	-- 					yank_last = "<C-y>",
	-- 					yank_last_code = "<C-k>",
	-- 					scroll_up = "<C-u>",
	-- 					scroll_down = "<C-d>",
	-- 					new_session = "<C-n>",
	-- 					cycle_windows = "<Tab>",
	-- 					cycle_modes = "<C-f>",
	-- 					next_message = "<C-j>",
	-- 					prev_message = "<C-k>",
	-- 					select_session = "<Space>",
	-- 					rename_session = "r",
	-- 					delete_session = "d",
	-- 					draft_message = "<C-r>",
	-- 					edit_message = "e",
	-- 					delete_message = "d",
	-- 					toggle_settings = "<C-o>",
	-- 					toggle_sessions = "<C-p>",
	-- 					toggle_help = "<C-h>",
	-- 					toggle_message_role = "<C-r>",
	-- 					toggle_system_role_open = "<C-s>",
	-- 					stop_generating = "<C-x>",
	-- 				},
	-- 			},
	-- 			popup_layout = {
	-- 				default = "center",
	-- 				center = {
	-- 					width = "80%",
	-- 					height = "80%",
	-- 				},
	-- 				right = {
	-- 					width = "30%",
	-- 					width_settings_open = "50%",
	-- 				},
	-- 			},
	-- 			popup_window = {
	-- 				border = {
	-- 					highlight = "FloatBorder",
	-- 					style = "rounded",
	-- 					text = {
	-- 						top = " ChatGPT ",
	-- 					},
	-- 				},
	-- 				win_options = {
	-- 					wrap = true,
	-- 					linebreak = true,
	-- 					foldcolumn = "1",
	-- 					winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
	-- 				},
	-- 				buf_options = {
	-- 					filetype = "markdown",
	-- 				},
	-- 			},
	-- 			system_window = {
	-- 				border = {
	-- 					highlight = "FloatBorder",
	-- 					style = "rounded",
	-- 					text = {
	-- 						top = " SYSTEM ",
	-- 					},
	-- 				},
	-- 				win_options = {
	-- 					wrap = true,
	-- 					linebreak = true,
	-- 					foldcolumn = "2",
	-- 					winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
	-- 				},
	-- 			},
	-- 			popup_input = {
	-- 				prompt = "  ",
	-- 				border = {
	-- 					highlight = "FloatBorder",
	-- 					style = "rounded",
	-- 					text = {
	-- 						top_align = "center",
	-- 						top = " Prompt ",
	-- 					},
	-- 				},
	-- 				win_options = {
	-- 					winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
	-- 				},
	-- 				submit = "<C-Enter>",
	-- 				submit_n = "<Enter>",
	-- 				max_visible_lines = 20,
	-- 			},
	-- 			openai_params = {
	-- 				model = "gpt-3.5-turbo",
	-- 				frequency_penalty = 0,
	-- 				presence_penalty = 0,
	-- 				max_tokens = 300,
	-- 				temperature = 0,
	-- 				top_p = 1,
	-- 				n = 1,
	-- 			},
	-- 			openai_edit_params = {
	-- 				model = "gpt-3.5-turbo",
	-- 				frequency_penalty = 0,
	-- 				presence_penalty = 0,
	-- 				temperature = 0,
	-- 				top_p = 1,
	-- 				n = 1,
	-- 			},
	-- 		})
	-- 	end,
	-- },
}
