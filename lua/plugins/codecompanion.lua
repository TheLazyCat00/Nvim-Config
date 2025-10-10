local maxTokens = {
	default = 30000,
	desc = "The maximum number of tokens to generate in the chat completion. The total length of input tokens and generated tokens is limited by the model's context length.",
}

return {
	"olimorris/codecompanion.nvim",
	enabled = vim.g.ai_assistant == "codecompanion",
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
							default = "claude-3.5-sonnet",
						},
						max_tokens = maxTokens
					},
				})
			end,
		},
		-- extensions = {
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
		-- },
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
					completion = {
						modes = {
							i = "<C-_>",
						},
					},
					regenerate = {
						modes = {
							n = "<leader>ar",
						},
					},
					stop = {
						modes = {
							n = "<leader>aq",
						},
					},
					clear = {
						modes = {
							n = "<leader>ax",
						},
					},
					codeblock = {
						modes = {
							n = "<leader>ac",
						},
					},
					yank_code = {
						modes = {
							n = "<leader>ay",
						},
					},
					pin = {
						modes = {
							n = "<leader>ap",
						},
					},
					watch = {
						modes = {
							n = "<leader>aw",
						},
					},
					change_adapter = {
						modes = {
							n = "<leader>a?",
						},
					},
					fold_code = {
						modes = {
							n = "<leader>af",
						},
					},
					debug = {
						modes = {
							n = "<leader>ad",
						},
					},
					system_prompt = {
						modes = {
							n = "<leader>as",
						},
					},
				},
			},
			inline = {
				keymaps = {
					accept_change = {
						modes = {
							n = "<leader>ay",
						},
					},
					reject_change = {
						modes = {
							n = "<leader>ax",
						},
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
