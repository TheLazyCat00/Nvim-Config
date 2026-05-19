return {
	"frankroeder/parrot.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/which-key.nvim",
	},
	opts = {
		providers = {
			mistral = {
				name = "mistral",
				api_key = os.getenv("MISTRAL_API_KEY"),
				endpoint = "https://api.mistral.ai/v1/chat/completions",
				model_endpoint = "https://api.mistral.ai/v1/models",
				params = {
					chat = { temperature = 0.7, top_p = 1 },
					command = { temperature = 0.7, top_p = 1 },
				},
				topic = {
					model = "mistral-small-latest",
					params = { max_completion_tokens = 64 },
				},
				models = {
					"mistral-large-latest",
					"codestral-latest",
					"mistral-small-latest",
					"mistral-medium-latest",
				},
			},
		},

		cmd_prefix = "Prt",

		state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/persisted",
		chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/chats",

		chat_user_prefix = "🗨:",
		llm_prefix = "🦜:",

		chat_shortcut_respond = { modes = { "n", "i", "x" }, shortcut = "<C-CR>" },
		chat_shortcut_delete = { modes = { "n", "i", "x" }, shortcut = "<C-g>d" },
		chat_shortcut_stop = { modes = {"n", "i"}, shortcut = "<C-g>s" },
		chat_shortcut_new = { modes = { "n", "i" }, shortcut = "<C-g>c" },

		chat_confirm_delete = true,
		chat_free_cursor = true,
		toggle_target = "popup",
		user_input_ui = "native",

		-- Popup window layout
		style_popup_border = "single",
		style_popup_margin_bottom = 8,
		style_popup_margin_left = 1,
		style_popup_margin_right = 2,
		style_popup_margin_top = 2,
		style_popup_max_width = 160,

		command_auto_select_response = true,
		model_cache_expiry_hours = 48,
	},

	keys = {
		-- Chat commands
		{ "<leader>at", "<cmd>PrtChatToggle<CR>", mode = "n", desc = "Toggle Parrot Chat" },
		{ "<leader>aa", "<cmd>PrtChatNew<CR>", mode = "n", desc = "New Parrot Chat" },
		{ "<leader>ap", "<cmd>PrtChatPaste<CR>", mode = "x", desc = "Paste to Parrot Chat" },

		-- Interactive commands
		{ "<leader>ai", ":PrtRewrite ", mode = { "n", "x" }, desc = "Parrot Rewrite" },
		{ "<leader>an", "<cmd>PrtRetry<CR>", mode = { "n", "x" }, desc = "Parrot Retry" },
		{ "<leader>ae", "<cmd>PrtEdit<CR>", mode = { "n", "x" }, desc = "Parrot Edit" },
		{ "<leader>ab", ":PrtAppend ", mode = { "n", "x" }, desc = "Parrot Append" },
		{ "<leader>ac", ":PrtPrepend ", mode = { "n", "x" }, desc = "Parrot Prepend" },

		-- Model and provider commands
		{ "<leader>am", "<cmd>PrtModel<CR>", mode = "n", desc = "Parrot Model" },
		{ "<leader>aP", "<cmd>PrtProvider<CR>", mode = "n", desc = "Parrot Provider" },
		{ "<leader>as", "<cmd>PrtStatus<CR>", mode = "n", desc = "Parrot Status" },
		{ "<leader>aq", "<cmd>PrtStop<CR>", mode = "n", desc = "Parrot Stop" },

		-- Other commands
		{ "<leader>af", "<cmd>PrtChatFinder<CR>", mode = "n", desc = "Parrot Chat Finder" },
		{ "<leader>ad", "<cmd>PrtChatDelete<CR>", mode = "n", desc = "Parrot Chat Delete" },
		{ "<leader>ar", "<cmd>PrtContext<CR>", mode = "n", desc = "Parrot Context" },
		{ "<leader>a?", "<cmd>PrtInfo<CR>", mode = "n", desc = "Parrot Info" },
	},
}
