return {
	"olimorris/codecompanion.nvim",
	-- enabled = vim.g.ai_assistant == "codecompanion",
	enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"folke/which-key.nvim",
	},
	opts = {
		adapters = {
			acp = {
				opts = {
					show_presets = false,
				},
			},
			http = {
				opts = {
					show_presets = false,
					show_model_choices = true,
				},
			},
		},
		interactions = {
			-- BACKGROUND INTERACTION -------------------------------------------------
			background = {
				adapter = {
					name = "copilot",
					model = "claude-haiku-4.5",
				},
				-- Callbacks within the plugin that you can attach background actions to
				chat = {
					callbacks = {
						["on_ready"] = {
							actions = {
								"interactions.background.builtin.chat_make_title",
							},
							enabled = true,
						},
					},
					opts = {
						enabled = false, -- Enable ALL background chat interactions?
					},
				},
			},
			-- CHAT INTERACTION -------------------------------------------------------
			chat = {
				adapter = {
					name = "copilot",
					model = "claude-haiku-4.5",
				},
				roles = {
					---The header name for the LLM's messages
					---@type string|fun(adapter: CodeCompanion.HTTPAdapter|CodeCompanion.ACPAdapter): string
					llm = function(adapter)
						return "CodeCompanion (" .. adapter.parameters.model .. ")"
					end,

					---The header name for your messages
					---@type string
					user = "Me",
				},
				tools = {
					opts = {
						---Tools and/or groups that are always loaded in a chat buffer
						---@type string[]
						default_tools = {},
					},
				},
				variables = {
				},
				slash_commands = {
					["buffer"] = {
						callback = "interactions.chat.slash_commands.builtin.buffer",
						description = "Insert open buffers",
						opts = {
							contains_code = true,
							default_params = "diff", -- all|diff
							provider = vim.g.lazyvim_picker, -- telescope|fzf_lua|mini_pick|snacks|default
						},
					},
					["fetch"] = {
						callback = "interactions.chat.slash_commands.builtin.fetch",
						description = "Insert URL contents",
						opts = {
							adapter = "jina", -- jina
							cache_path = vim.fn.stdpath("data") .. "/codecompanion/urls",
							provider = vim.g.lazyvim_picker, -- telescope|fzf_lua|mini_pick|snacks|default
						},
					},
					["file"] = {
						callback = "interactions.chat.slash_commands.builtin.file",
						description = "Insert a file",
						opts = {
							contains_code = true,
							max_lines = 1000,
							provider = vim.g.lazyvim_picker, -- telescope|fzf_lua|mini_pick|snacks|default
						},
					},
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
					buffer_sync_all = {
						modes = {
							n = "<leader>ag",
						},
					},
					buffer_sync_diff = {
						modes = {
							n = "<leader>ab",
						},
					},
				},
			},
			-- INLINE INTERACTION -----------------------------------------------------
			inline = {
				adapter = "copilot",
				keymaps = {
					accept_change = {
						modes = {
							n = "<leader>ay",
						},
						opts = {},
					},
					reject_change = {
						modes = {
							n = "<leader>ax",
						},
						opts = {},
					},
				},
			},
		},
		opts = {
			log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
			language = "English", -- The language used for LLM responses

			-- If this is false then any default prompt that is marked as containing code
			-- will not be sent to the LLM. Please note that whilst I have made every
			-- effort to ensure no code leakage, using this is at your own risk
			---@type boolean|function
			---@return boolean
			send_code = true,

			job_start_delay = 1500, -- Delay in milliseconds between cmd tools
			submit_delay = 2000, -- Delay in milliseconds before auto-submitting the chat buffer
		},
	},
	keys = {
		{"<leader>at", "<cmd>CodeCompanionChat Toggle<CR>", mode = "n", desc = "Toggle Companion"},
		{"<leader>aa", "<cmd>CodeCompanionActions<CR>", mode = "n", desc = "Companion Actions"},
		{"<leader>ai", "<cmd>CodeCompanion<CR>", mode = "n", desc = "Inline Assistant"},
		{"<leader>ap", "<cmd>CodeCompanionChat Add<CR>", mode = "x", desc = "Add Selected to Chat"},
	}
}
