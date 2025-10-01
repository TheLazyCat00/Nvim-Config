local maxTokens = {
	default = 30000,
	desc = "The maximum number of tokens to generate in the chat completion. The total length of input tokens and generated tokens is limited by the model's context length.",
}

return {
	"olimorris/codecompanion.nvim",
	enabled = vim.g.ai_assistant == "codecompanion",
	-- branch = "has-xml-tools",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"folke/which-key.nvim",
		-- "ravitemer/codecompanion-history.nvim"
	},
	opts = {
		display = {
			action_palette = {
				width = 95,
				height = 10,
				prompt = "Prompt ", -- Prompt used for interactive LLM calls
				provider = "default", -- default|telescope|mini_pick
				opts = {
					show_default_actions = true, -- Show the default actions in the action palette?
					show_default_prompt_library = true, -- Show the default prompt library in the action palette?
				},
			},
		},
		adapters = {
			opts = {
				show_defaults = false,
				cache_models_for = 1800,
				show_model_choices = true,
			},

			["copilot"] = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "claude-sonnet-4",
						},
						max_tokens = maxTokens
					},
				})
			end,
		},
		extensions = {
			-- history = {
			-- 	enabled = true,
			-- 	opts = {
			-- 		-- Keymap to open history from chat buffer (default: gh)
			-- 		keymap = "<leader>ah",
			-- 		-- Automatically generate titles for new chats
			-- 		auto_generate_title = true,
			-- 		---On exiting and entering neovim, loads the last chat on opening chat
			-- 		continue_last_chat = true,
			-- 		---When chat is cleared with `gx` delete the chat from history
			-- 		delete_on_clearing_chat = false,
			-- 		-- Picker interface ("telescope", "snacks" or "default")
			-- 		picker = "snacks",
			-- 		---Enable detailed logging for history extension
			-- 		enable_logging = false,
			-- 		---Directory path to save the chats
			-- 		dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
			-- 		-- Save all chats by default
			-- 		auto_save = true,
			-- 		-- Keymap to save the current chat manually
			-- 		save_chat_keymap = "<leader>ab",
			-- 	}
			-- }
		},
		strategies = {
			-- Change the default chat adapter
			chat = {
				adapter = "copilot",
				tools = {
					["insert_edit_into_file"] = {
						callback = "strategies.chat.tools.catalog.insert_edit_into_file",
						description = "Insert code into an existing file",
						opts = {
							patching_algorithm = "strategies.chat.tools.catalog.helpers.patch",
							-- requires_approval = { -- Require approval before the tool is executed?
							-- 	buffer = false, -- For editing buffers in Neovim
							-- 	file = false, -- For editing files in the current working directory
							-- },
							-- user_confirmation = false, -- Require confirmation from the user before accepting the edit?
						},
					},
				},
				slash_commands = {
					["file"] = {
						-- Location to the slash command in CodeCompanion
						callback = "strategies.chat.slash_commands.file",
						opts = {
							provider = vim.g.lazyvim_picker, -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
							contains_code = true,
						},
					},
					["buffer"] = {
						-- Location to the slash command in CodeCompanion
						callback = "strategies.chat.slash_commands.buffer",
						opts = {
							provider = vim.g.lazyvim_picker, -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
							contains_code = true,
						},
					},
				},

				roles = {
					---The header name for the LLM's messages
					---@type string|fun(adapter: CodeCompanion.Adapter): string
					llm = function(adapter)
						return "CodeCompanion (" .. adapter.parameters.model .. ")"
					end,

					---The header name for your messages
					---@type string
					user = "Me",
				},
				keymaps = {
					options = {
						modes = {
							n = "?",
						},
						callback = "keymaps.options",
						description = "Options",
						hide = true,
					},
					completion = {
						modes = {
							i = "<C-_>",
						},
						index = 1,
						callback = "keymaps.completion",
						description = "Completion Menu",
					},
					send = {
						modes = {
							n = { "<CR>", "<C-s>" },
							i = "<C-s>",
						},
						index = 2,
						callback = "keymaps.send",
						description = "Send",
					},
					regenerate = {
						modes = {
							n = "<leader>ar",
						},
						index = 3,
						callback = "keymaps.regenerate",
						description = "Regenerate the last response",
					},
					close = {
						modes = {
							n = "<C-c>",
							i = "<C-c>",
						},
						index = 4,
						callback = "keymaps.close",
						description = "Close Chat",
					},
					stop = {
						modes = {
							n = "<leader>aq",
						},
						index = 5,
						callback = "keymaps.stop",
						description = "Stop Request",
					},
					clear = {
						modes = {
							n = "<leader>ax",
						},
						index = 6,
						callback = "keymaps.clear",
						description = "Clear Chat",
					},
					codeblock = {
						modes = {
							n = "<leader>ac",
						},
						index = 7,
						callback = "keymaps.codeblock",
						description = "Insert Codeblock",
					},
					yank_code = {
						modes = {
							n = "<leader>ay",
						},
						index = 8,
						callback = "keymaps.yank_code",
						description = "Yank Code",
					},
					pin = {
						modes = {
							n = "<leader>ap",
						},
						index = 9,
						callback = "keymaps.pin_context",
						description = "Pin Reference",
					},
					watch = {
						modes = {
							n = "<leader>aw",
						},
						index = 10,
						callback = "keymaps.toggle_watch",
						description = "Watch Buffer",
					},
					next_chat = {
						modes = {
							n = "}",
						},
						index = 11,
						callback = "keymaps.next_chat",
						description = "Next Chat",
					},
					previous_chat = {
						modes = {
							n = "{",
						},
						index = 12,
						callback = "keymaps.previous_chat",
						description = "Previous Chat",
					},
					next_header = {
						modes = {
							n = "]]",
						},
						index = 13,
						callback = "keymaps.next_header",
						description = "Next Header",
					},
					previous_header = {
						modes = {
							n = "[[",
						},
						index = 14,
						callback = "keymaps.previous_header",
						description = "Previous Header",
					},
					change_adapter = {
						modes = {
							n = "<leader>a?",
						},
						index = 15,
						callback = "keymaps.change_adapter",
						description = "Change adapter",
					},
					fold_code = {
						modes = {
							n = "<leader>af",
						},
						index = 15,
						callback = "keymaps.fold_code",
						description = "Fold code",
					},
					debug = {
						modes = {
							n = "<leader>ad",
						},
						index = 16,
						callback = "keymaps.debug",
						description = "View debug info",
					},
					system_prompt = {
						modes = {
							n = "<leader>as",
						},
						index = 17,
						callback = "keymaps.toggle_system_prompt",
						description = "Toggle the system prompt",
					},
					auto_tool_mode = {
						modes = {
							n = "<leader>ag",
						},
						index = 18,
						callback = "keymaps.auto_tool_mode",
						description = "Toggle automatic tool mode",
					},
				},
			},
			inline = {
				keymaps = {
					accept_change = {
						modes = {
							n = "<leader>ay",
						},
						index = 1,
						callback = "keymaps.accept_change",
						description = "Accept change",
					},
					reject_change = {
						modes = {
							n = "<leader>ax",
						},
						index = 2,
						callback = "keymaps.reject_change",
						description = "Reject change",
					},
				},
			},
		},
	},
	keys = {
		{"<leader>at", "<cmd>CodeCompanionChat Toggle<CR>", mode = "n", desc = "Toggle Companion"},
		{"<leader>aa", "<cmd>CodeCompanionActions<CR>", mode = "n", desc = "Companion Actions"},
		{"<leader>ai", "<cmd>CodeCompanion<CR>", mode = "n", desc = "Inline Assistant"},
		{"<leader>ap", "<cmd>CodeCompanionChat Add<CR>", mode = "x", desc = "Add Selected to Chat"},
	}
}
