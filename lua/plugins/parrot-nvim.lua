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
	config = function()
		local parrot = require("parrot")
		parrot.setup(require("lazy.core.plugin").values({
			mod = "parrot.nvim",
		}, "opts"))

		-- Store state for aerial window replacement
		local aerial_was_open = false
		local aerial = require("aerial")

		-- Override the toggle command to handle aerial replacement
		local original_toggle = vim.cmd.PrtChatToggle
		
		-- Create a custom toggle function
		local function toggle_parrot_chat()
			local aerial_is_open = aerial and aerial.is_open and aerial.is_open() or false
			
			if aerial_is_open then
				aerial_was_open = true
				aerial.close()
				-- Open parrot in a vertical split with same width as aerial (20%)
				vim.cmd("vsplit")
				vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.2))
				vim.cmd("PrtChatToggle")
			else
				-- Check if parrot chat is currently open
				local parrot_chat_open = false
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.bo[buf].filetype == "parrot-chat" then
						parrot_chat_open = true
						break
					end
				end
				
				if parrot_chat_open then
					-- Close parrot and reopen aerial if it was open before
					vim.cmd("PrtChatToggle")
					if aerial_was_open then
						aerial_was_open = false
						vim.schedule(function()
							aerial.open({ focus = false })
						end)
					end
				else
					-- Open parrot normally
					vim.cmd("PrtChatToggle")
				end
			end
		end

		-- Create command that wraps our custom toggle
		vim.api.nvim_create_user_command("PrtChatToggle", toggle_parrot_chat, {})
		
		-- Also handle the case when parrot chat is closed directly
		vim.api.nvim_create_autocmd("WinClosed", {
			pattern = "*",
			callback = function(args)
				local buf = vim.api.nvim_win_get_buf(tonumber(args.match))
				if vim.bo[buf].filetype == "parrot-chat" then
					-- Check if any parrot chat windows are still open
					local any_parrot_open = false
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local b = vim.api.nvim_win_get_buf(win)
						if vim.bo[b].filetype == "parrot-chat" then
							any_parrot_open = true
							break
						end
					end
					
					if not any_parrot_open and aerial_was_open then
						aerial_was_open = false
						vim.schedule(function()
							aerial.open({ focus = false })
						end)
					end
				end
			end,
		})
	end,
}
