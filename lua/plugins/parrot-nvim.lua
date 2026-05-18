return {
	"frankroeder/parrot.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ibhagwan/fzf-lua",
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
					"codestral-latest",
					"mistral-small-latest",
					"mistral-medium-latest",
					"mistral-large-latest",
				},
			},
		},

		system_prompt = {
			chat = "You are a helpful coding assistant. Be concise and to the point. Always provide code examples when relevant.",
			command = "You are a helpful coding assistant. Follow the user's instructions precisely. Only respond with the code or text that should replace the selection.",
		},

		cmd_prefix = "Prt",

		-- The directory to store persisted state information
		state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/persisted",

		-- The directory to store the chats
		chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/chats",

		-- Chat user prompt prefix
		chat_user_prefix = "🗨:",

		-- LLM prompt prefix
		llm_prefix = "🦜:",

		-- Explicitly confirm deletion of a chat file
		chat_confirm_delete = true,

		-- Local chat buffer shortcuts
		chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
		chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
		chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
		chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },

		-- Option to move the cursor to the end of the file after finished respond
		chat_free_cursor = false,

		-- Default target for PrtChatToggle, PrtChatNew, PrtContext
		toggle_target = "vsplit",

		-- The interactive user input
		user_input_ui = "native",

		-- Popup window layout
		style_popup_border = "single",
		style_popup_margin_bottom = 8,
		style_popup_margin_left = 1,
		style_popup_margin_right = 2,
		style_popup_margin_top = 2,
		style_popup_max_width = 160,

		-- auto select command response
		command_auto_select_response = true,

		-- Time in hours until the model cache is refreshed
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
