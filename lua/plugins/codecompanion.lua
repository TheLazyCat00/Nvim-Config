local reasoningEffort = {
	default = "medium",
	desc = "Constrains effort on reasoning for reasoning models. Reducing reasoning effort can result in faster responses and fewer tokens used on reasoning in a response.",
	choices = {
		"high",
		"medium",
		"low",
	},
}

local maxTokens = {
	default = nil,
	desc = "The maximum number of tokens to generate in the chat completion. The total length of input tokens and generated tokens is limited by the model's context length.",
}
return {
	"olimorris/codecompanion.nvim",
	event = "UIEnter",
	enabled = vim.g.ai_assistant == "codecompanion",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"folke/which-key.nvim",
	},
	opts = {
		strategies = {
			-- Change the default chat adapter
			chat = {
				adapter = "copilot",

				slash_commands = {
					["file"] = {
						-- Location to the slash command in CodeCompanion
						callback = "strategies.chat.slash_commands.file",
						description = "Select a file using Telescope",
						opts = {
							provider = "telescope", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
							contains_code = true,
						},
					},
					["buffer"] = {
						-- Location to the slash command in CodeCompanion
						callback = "strategies.chat.slash_commands.buffer",
						description = "Select a buffer using Telescope",
						opts = {
							provider = "telescope", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
							contains_code = true,
						},
					},
				},

				roles = {
					---The header name for the LLM's messages
					---@type string|fun(adapter: CodeCompanion.Adapter): string
					llm = function(adapter)
						return "CodeCompanion (" .. adapter.formatted_name .. ")"
					end,

					---The header name for your messages
					---@type string
					user = "Me",
				}
			},
		},
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
				cache_models_for = 1800
			},

			["copilot"] = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "claude-3.7-sonnet",
						},
						max_tokens = maxTokens
					},
				})
			end,

			-- ["claude-3.5-sonnet"] = function()
			-- 	return require("codecompanion.adapters").extend("copilot", {
			-- 		name = "claude-3.5-sonnet",
			-- 		schema = {
			-- 			model = {
			-- 				default = "claude-3.5-sonnet",
			-- 			},
			-- 			max_tokens = maxTokens
			-- 		},
			-- 	})
			-- end,

			-- ["o3-mini"] = function()
			-- 	return require("codecompanion.adapters").extend("copilot", {
			-- 		name = "o3-mini",
			-- 		schema = {
			-- 			model = {
			-- 				default = "o3-mini",
			-- 			},
			-- 			max_tokens = maxTokens
			-- 		},
			-- 	})
			-- end,
		}
	},
	init = function()
		local wk = require("which-key")
		wk.add({
			{
				mode = "n",
				{"<leader>at", ":CodeCompanionChat Toggle<CR>", desc = "Toggle Companion"},
				{"<leader>aa", ":CodeCompanionActions<CR>", desc = "Companion Actions"},
				{"<leader>ai", ":CodeCompanion<CR>", desc = "Inline Assistant"},
			},
			{
				mode = "x",
				{"<leader>ap", ":CodeCompanionChat Add<CR>", desc = "Add Selected to Chat"},
			}
		})
	end,
}
