return {
	"CopilotC-Nvim/CopilotChat.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"folke/which-key.nvim",
		"folke/snacks.nvim",
	},
	build = "make tiktoken",
	opts = function()
		local data_dir = vim.fn.stdpath("data"):gsub("/$", "")

		-- "read-only tools" we allow the LLM to call
		local ro_tools = { "file", "glob", "grep", "gitdiff", "buffer" }

		return {
			-- Default model: Mistral (provider added in config() below)
			model = "mistral-small-latest",
			system_prompt = "Be concise. Get to the point. No fluff.",
			temperature = 0.2,

			resources = "selection",
			selection = "visual",

			-- read-only tool set
			tools = ro_tools,
			trusted_tools = ro_tools,

			window = {
				layout = "float",
				border = "single",
				width = 160,
				height = 25,
				title = "Copilot Chat",
			},

			show_help = true,
			auto_follow_cursor = true,
			auto_insert_mode = false,
			clear_chat_on_new_prompt = false,

			headers = {
				user = "🗨:",
				assistant = ":",
				tool = "Tool",
			},

			-- if you're using blink completion for copilot-chat filetype
			chat_autocomplete = false,

			history_path = data_dir .. "/copilotchat/chats",
			log_path = vim.fn.stdpath("state") .. "/CopilotChat.log",

			instruction_files = { ".github/copilot-instructions.md", "AGENTS.md" },
		}
	end,

	config = function(_, opts)
		-- -----------------------------------------------------------------------
		-- Providers: add Mistral + (optionally) disable Copilot/GitHub providers
		-- -----------------------------------------------------------------------
		local cfg = require("CopilotChat.config")

		-- If your goal is “Mistral only” (no GitHub auth), disable these:
		if cfg.providers and cfg.providers.copilot then
			cfg.providers.copilot.disabled = true
		end
		if cfg.providers and cfg.providers.github_models then
			cfg.providers.github_models.disabled = true
		end

		cfg.providers.mistral = {
			prepare_input = require("CopilotChat.config.providers").copilot.prepare_input,
			prepare_output = require("CopilotChat.config.providers").copilot.prepare_output,

			get_headers = function()
				local api_key = assert(os.getenv("MISTRAL_API_KEY"), "MISTRAL_API_KEY env not set")
				return {
					Authorization = "Bearer " .. api_key,
					["Content-Type"] = "application/json",
				}
			end,

			get_models = function(headers)
				local response, err = require("CopilotChat.utils").http_get("https://api.mistral.ai/v1/models", {
					headers = headers,
					json_response = true,
				})
				if err then
					error(err)
				end

				-- Keep it close to your Parrot list (but you can remove this filter if you want all models)
				local allow = {
					["mistral-large-latest"] = true,
					["codestral-latest"] = true,
					["mistral-small-latest"] = true,
					["mistral-medium-latest"] = true,
				}

				return vim
					.iter(response.body.data)
					:filter(function(model)
						return model.capabilities and model.capabilities.completion_chat and allow[model.id]
					end)
					:map(function(model)
						return { id = model.id, name = model.name }
					end)
					:totable()
			end,

			get_url = function()
				return "https://api.mistral.ai/v1/chat/completions"
			end,
		}

		-- Now start CopilotChat
		local chat = require("CopilotChat")
		chat.setup(opts)

		-- -----------------------------------------------------------------------
		-- Per-project persistent chat
		-- -----------------------------------------------------------------------
		local function project_root()
			local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2> /dev/null")[1]
			if git_root and git_root ~= "" then
				return git_root
			end
			return vim.uv.cwd() or vim.fn.getcwd()
		end

		local function project_chat_name()
			local root = project_root()
			local base = vim.fn.fnamemodify(root, ":t")
			local ok, hash = pcall(vim.fn.sha256, root)
			if ok and type(hash) == "string" and #hash > 0 then
				return string.format("%s-%s", base, hash:sub(1, 10))
			end
			return base
		end

		local function history_file(name)
			return vim.fs.normalize(opts.history_path .. "/" .. name .. ".json")
		end

		local function load_project_chat()
			local name = project_chat_name()
			if vim.uv.fs_stat(history_file(name)) then
				pcall(chat.load, name, opts.history_path)
			end
		end

		local function save_project_chat()
			local name = project_chat_name()
			pcall(chat.save, name, opts.history_path)
		end

		load_project_chat()

		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = save_project_chat,
		})
		vim.api.nvim_create_autocmd("DirChanged", {
			callback = function()
				save_project_chat()
				load_project_chat()
			end,
		})

		vim.api.nvim_create_user_command("CopilotChatProjectSave", save_project_chat, {})
		vim.api.nvim_create_user_command("CopilotChatProjectLoad", load_project_chat, {})
		vim.api.nvim_create_user_command("CopilotChatProjectNew", function()
			save_project_chat()
			chat.reset()
		end, {})

		-- -----------------------------------------------------------------------
		-- Parrot-like prompts: Rewrite / Append / Prepend
		-- -----------------------------------------------------------------------
		chat.setup({
			prompts = vim.tbl_extend("force", require("CopilotChat.config.prompts"), {
				Rewrite = {
					description = "Rewrite selection (read-only repo exploration enabled)",
					prompt = table.concat({
						"Rewrite the selected code according to the user's instruction.",
						"You MAY use the available read-only tools (file/glob/grep/gitdiff/buffer) to inspect the codebase before answering.",
						"Return the replacement as CopilotChat edit blocks (path/start_line/end_line).",
						"Be concise; no extra commentary unless asked.",
					}, "\n"),
					resources = "selection",
					tools = { "file", "glob", "grep", "gitdiff", "buffer" },
				},

				Append = {
					description = "Append to selection (replace selection with selection+new content)",
					prompt = table.concat({
						"Append new code/content to the selected code according to the user's instruction.",
						"Return the full replacement for the selected range as CopilotChat edit blocks (path/start_line/end_line).",
						"You MAY use read-only tools (file/glob/grep/gitdiff/buffer) first.",
						"Be concise.",
					}, "\n"),
					resources = "selection",
					tools = { "file", "glob", "grep", "gitdiff", "buffer" },
				},

				Prepend = {
					description = "Prepend to selection (replace selection with new content+selection)",
					prompt = table.concat({
						"Prepend new code/content before the selected code according to the user's instruction.",
						"Return the full replacement for the selected range as CopilotChat edit blocks (path/start_line/end_line).",
						"You MAY use read-only tools (file/glob/grep/gitdiff/buffer) first.",
						"Be concise.",
					}, "\n"),
					resources = "selection",
					tools = { "file", "glob", "grep", "gitdiff", "buffer" },
				},
			}),
		})

		-- Retry (Parrot-ish)
		vim.api.nvim_create_user_command("CopilotChatRetry", function()
			local constants = require("CopilotChat.constants")
			local last_user = chat.chat:get_message(constants.ROLE.USER, true)
			if last_user and last_user.content and vim.trim(last_user.content) ~= "" then
				chat.ask(last_user.content)
			end
		end, {})
	end,

	keys = {
		{ "<leader>at", "<cmd>CopilotChatToggle<CR>", mode = "n", desc = "Toggle Copilot Chat" },
		{ "<leader>an", "<cmd>CopilotChatProjectNew<CR>", mode = "n", desc = "New Chat (save+reset, per-project)" },

		{ "<leader>ai", ":CopilotChatRewrite ", mode = { "n", "x" }, desc = "Rewrite (selection)" },
		{ "<leader>aa", ":CopilotChatAppend ", mode = { "n", "x" }, desc = "Append (selection)" },
		{ "<leader>aS", ":CopilotChatPrepend ", mode = { "n", "x" }, desc = "Prepend (selection)" },
		{ "<leader>ae", "<cmd>CopilotChatFix<CR>", mode = { "n", "x" }, desc = "Fix (selection)" },

		{ "<leader>ar", "<cmd>CopilotChatRetry<CR>", mode = { "n", "x" }, desc = "Retry last prompt" },
		{ "<leader>aq", "<cmd>CopilotChatStop<CR>", mode = { "n", "x" }, desc = "Stop" },

		-- These use vim.ui.select -> Snacks picker now
		{ "<leader>am", "<cmd>CopilotChatModels<CR>", mode = "n", desc = "Select model" },
		{ "<leader>ac", "<cmd>CopilotChatPrompts<CR>", mode = "n", desc = "Prompt picker" },

		{ "<leader>as", "<cmd>CopilotChatProjectSave<CR>", mode = "n", desc = "Save project chat" },
		{ "<leader>aL", "<cmd>CopilotChatProjectLoad<CR>", mode = "n", desc = "Load project chat" },
	},
}
