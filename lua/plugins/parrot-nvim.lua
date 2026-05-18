local data_dir = vim.fn.stdpath("data"):gsub("/$", "")
local chat_dir = data_dir .. "/parrot/chats"
local default_sidebar_width = 0.2
local min_windows_for_sidebar_move = 2

local function is_parrot_sidebar_buffer(bufnr)
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end

	local name = vim.api.nvim_buf_get_name(bufnr)
	return vim.startswith(name, chat_dir .. "/") or name:match("/%.parrot%.md$")
end

local function find_window(predicate)
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)
		if predicate(win, buf) then
			return win, buf
		end
	end
end

local function find_aerial_window()
	return find_window(function(_, buf)
		return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "aerial"
	end)
end

local function find_parrot_sidebar_window()
	return find_window(function(_, buf)
		return is_parrot_sidebar_buffer(buf)
	end)
end

local function get_sidebar_state()
	vim.t.parrot_sidebar_state = vim.t.parrot_sidebar_state or {}
	return vim.t.parrot_sidebar_state
end

local function get_default_width()
	return math.max(20, math.floor(vim.o.columns * default_sidebar_width))
end

local function restore_aerial_sidebar()
	local state = vim.t.parrot_sidebar_state
	if not state or not state.restore_aerial then
		return
	end

	vim.schedule(function()
		if find_parrot_sidebar_window() or find_aerial_window() then
			return
		end

		state.restore_aerial = false

		local aerial = require("aerial")
		aerial.open(false, "left") -- keep focus in the code window

		local aerial_win = find_aerial_window()
		if aerial_win then
			pcall(vim.api.nvim_win_set_width, aerial_win, state.width or get_default_width())
		end
	end)
end

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
		state_dir = data_dir .. "/parrot/persisted",

		-- The directory to store the chats
		chat_dir = chat_dir,

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
	config = function(_, opts)
		require("parrot").setup(opts)

		local group = vim.api.nvim_create_augroup("ParrotSidebar", { clear = true })

		vim.api.nvim_create_autocmd("BufWinEnter", {
			group = group,
			callback = function(args)
				if not is_parrot_sidebar_buffer(args.buf) then
					return
				end

				local win = vim.fn.bufwinid(args.buf)
				if win == -1 or vim.api.nvim_win_get_config(win).relative ~= "" then
					return
				end

				local state = get_sidebar_state()
				local aerial_win = find_aerial_window()

				if aerial_win then
					state.restore_aerial = true
					state.width = vim.api.nvim_win_get_width(aerial_win)
					require("aerial").close()
				else
					state.width = state.width or get_default_width()
				end

				if #vim.api.nvim_tabpage_list_wins(0) >= min_windows_for_sidebar_move then
					vim.cmd("wincmd H")
				end

				local current_win = vim.api.nvim_get_current_win()
				vim.api.nvim_set_option_value("winfixwidth", true, { scope = "local", win = current_win })
				pcall(vim.api.nvim_win_set_width, current_win, state.width or get_default_width())
			end,
		})

		vim.api.nvim_create_autocmd("BufWinLeave", {
			group = group,
			callback = function(args)
				if is_parrot_sidebar_buffer(args.buf) then
					local current_win = vim.api.nvim_get_current_win()
					if vim.api.nvim_win_is_valid(current_win) and vim.api.nvim_win_get_buf(current_win) == args.buf then
						pcall(vim.api.nvim_set_option_value, "winfixwidth", false, { scope = "local", win = current_win })
					end
					vim.schedule(restore_aerial_sidebar)
				end
			end,
		})
	end,
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
