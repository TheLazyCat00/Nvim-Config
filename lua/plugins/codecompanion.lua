return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"folke/which-key.nvim",
	},
	opts = {
		-- Adapters -----------------------------------------------------------------
		adapters = {
			-- Keep ACP configured (even if you’re not using it) ----------------------
			acp = {
				opts = {
					show_presets = false,
				},
			},

			-- HTTP adapters (this is what Inline uses) -------------------------------
			http = {
				opts = {
					show_presets = false,
					show_model_choices = true,
				},

				-- IMPORTANT:
				-- You had `show_presets = false`, which hides built-in adapters unless
				-- you define them here. So we explicitly “extend” the built-in Mistral adapter.
				mistral = function()
					return require("codecompanion.adapters").extend("mistral", {
						schema = {
							model = {
								default = "codestral-latest", -- best default for “implement this function”
							},
							-- Optional: make it more deterministic for refactors/impl
							temperature = { default = 0 },
						},
					})
				end,
			},
		},

		-- Interactions -------------------------------------------------------------
		interactions = {
			-- BACKGROUND INTERACTION -------------------------------------------------
			background = {
				adapter = {
					name = "mistral",
					model = "mistral-small-latest",
				},
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
					name = "mistral",
					model = "codestral-latest",
				},
				roles = {
					llm = function(adapter)
						local model = (adapter.parameters and adapter.parameters.model)
						or (adapter.schema and adapter.schema.model and adapter.schema.model.default)
						or "unknown-model"
						return "CodeCompanion (" .. model .. ")"
					end,
					user = "Me",
				},
				tools = {
					opts = {
						default_tools = {},
					},
				},
				variables = {},
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
					completion = { modes = { i = "<C-_>" } },
					regenerate = { modes = { n = "<leader>ar" } },
					stop = { modes = { n = "<leader>aq" } },
					clear = { modes = { n = "<leader>ax" } },
					codeblock = { modes = { n = "<leader>ac" } },
					yank_code = { modes = { n = "<leader>ay" } },
					change_adapter = { modes = { n = "<leader>a?" } },
					fold_code = { modes = { n = "<leader>af" } },
					debug = { modes = { n = "<leader>ad" } },
					system_prompt = { modes = { n = "<leader>as" } },
					buffer_sync_all = { modes = { n = "<leader>ag" } },
					buffer_sync_diff = { modes = { n = "<leader>ab" } },
				},
			},

			-- INLINE INTERACTION -----------------------------------------------------
			-- Inline only supports HTTP adapters, so this must be the HTTP "mistral".
			inline = {
				adapter = {
					name = "mistral",
					model = "codestral-latest",
				},
				keymaps = {
					accept_change = {
						modes = { n = "<leader>ay" },
						opts = {},
					},
					reject_change = {
						modes = { n = "<leader>ax" },
						opts = {},
					},
				},
			},
		},

		-- Global plugin opts -------------------------------------------------------
		opts = {
			log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
			language = "English",
			send_code = true,
			job_start_delay = 1500,
			submit_delay = 2000,
		},
	},

	keys = {
		{ "<leader>at", "<cmd>CodeCompanionChat Toggle<CR>", mode = "n", desc = "Toggle Companion" },
		{ "<leader>aa", "<cmd>CodeCompanionActions<CR>", mode = "n", desc = "Companion Actions" },
		{ "<leader>ai", "<cmd>CodeCompanion<CR>", mode = { "n", "x" }, desc = "Inline Assistant" },
		{ "<leader>ap", "<cmd>CodeCompanionChat Add<CR>", mode = "x", desc = "Add Selected to Chat" },
	},
}
