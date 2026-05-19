return {
	"CopilotC-Nvim/CopilotChat.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"folke/which-key.nvim",
	},
	-- optional but recommended for better token counting / history mgmt
	build = "make tiktoken",
	opts = function()
		local data_dir = vim.fn.stdpath("data"):gsub("/$", "")

		-- "read-only tools" we allow the LLM to call
		local ro_tools = { "file", "glob", "grep", "gitdiff", "buffer" }

		return {
			-- Behavior / vibe
			system_prompt = "Be concise. Get to the point. No fluff.",
			temperature = 0.2,

			-- Default context for most asks (visual selection like Parrot)
			resources = "selection",
			selection = "visual",

			-- IMPORTANT: only share *read-only* tools by default
			-- (so the model can explore, but cannot write/execute)
			tools = ro_tools,
			trusted_tools = ro_tools, -- auto-run read-only tool calls without asking <!--citation:1-->

			-- UI
			window = {
				layout = "float",
				border = "single",
				width = 160,   -- columns (since > 1)
				height = 25,   -- rows
				title = "Copilot Chat",
			},
			show_help = true,
			auto_follow_cursor = true,
			auto_insert_mode = false,
			clear_chat_on_new_prompt = false, -- keep the conversation going

			-- Prefixes similar to your Parrot config
			headers = {
				user = "🗨:",
				assistant = "🦜:",
				tool = "Tool",
			},

			-- Persisted chat history location
			history_path = data_dir .. "/copilotchat/chats",
			log_path = vim.fn.stdpath("state") .. "/CopilotChat.log",

			-- Pick up repo instruction files automatically (defaults already include these)
			instruction_files = { ".github/copilot-instructions.md", "AGENTS.md" },
		}
	end,
	config = function(_, opts)
		local chat = require("CopilotChat")
		chat.setup(opts)

		-- --- Per-project persistent chat ---------------------------------------
		-- CopilotChat.save(name) writes: history_path .. "/" .. name .. ".json" <!--citation:2-->
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

		-- load once when plugin initializes (so your first rewrite already has context)
		load_project_chat()

		-- auto-save on exit; auto-save+load when changing directories
		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = save_project_chat,
		})
		vim.api.nvim_create_autocmd("DirChanged", {
			callback = function()
				save_project_chat()
				load_project_chat()
			end,
		})

		-- convenience user commands (like Parrot chat finder-ish workflows)
		vim.api.nvim_create_user_command("CopilotChatProjectSave", save_project_chat, {})
		vim.api.nvim_create_user_command("CopilotChatProjectLoad", load_project_chat, {})
		vim.api.nvim_create_user_command("CopilotChatProjectNew", function()
			save_project_chat()
			chat.reset() -- clears current buffer and starts fresh <!--citation:1-->
		end, {})

		-- --- Parrot-like prompts: Rewrite / Append / Prepend --------------------
		-- CopilotChat automatically creates :CopilotChat<PromptName> commands
		-- for anything you put into opts.prompts. <!--citation:2-->
		chat.setup({
			prompts = vim.tbl_extend("force", require("CopilotChat.config.prompts"), {
				-- Like :PrtRewrite <instruction>
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

		-- --- Retry (Parrot's :PrtRetry equivalent) ------------------------------
		vim.api.nvim_create_user_command("CopilotChatRetry", function()
			local constants = require("CopilotChat.constants")
			local last_user = chat.chat:get_message(constants.ROLE.USER, true)
			if last_user and last_user.content and vim.trim(last_user.content) ~= "" then
				chat.ask(last_user.content)
			end
		end, {})
	end,
	keys = {
		-- Chat commands (Parrot-ish)
		{ "<leader>at", "<cmd>CopilotChatToggle<CR>", mode = "n", desc = "Toggle Copilot Chat" },
		{ "<leader>an", "<cmd>CopilotChatProjectNew<CR>", mode = "n", desc = "New Chat (save+reset, per-project)" },

		-- “Interactive” edits (your Parrot Rewrite/Append/Prepend)
		-- NOTE: these commands accept trailing args, so mapping to ":Cmd " matches your Parrot UX
		{ "<leader>ai", ":CopilotChatRewrite ", mode = { "n", "x" }, desc = "Rewrite (selection)" },
		{ "<leader>aa", ":CopilotChatAppend ", mode = { "n", "x" }, desc = "Append (selection)" },
		{ "<leader>aS", ":CopilotChatPrepend ", mode = { "n", "x" }, desc = "Prepend (selection)" },

		-- Built-in “Fix” (quick equivalent of Parrot Edit-ish)
		{ "<leader>ae", "<cmd>CopilotChatFix<CR>", mode = { "n", "x" }, desc = "Fix (selection)" },

		-- Retry / Stop
		{ "<leader>ar", "<cmd>CopilotChatRetry<CR>", mode = { "n", "x" }, desc = "Retry last prompt" },
		{ "<leader>aq", "<cmd>CopilotChatStop<CR>", mode = { "n", "x" }, desc = "Stop" },

		-- Model / Prompt pickers
		{ "<leader>am", "<cmd>CopilotChatModels<CR>", mode = "n", desc = "Select model" },
		{ "<leader>ac", "<cmd>CopilotChatPrompts<CR>", mode = "n", desc = "Prompt picker" },

		-- Save/load current project chat explicitly (optional, but nice)
		{ "<leader>as", "<cmd>CopilotChatProjectSave<CR>", mode = "n", desc = "Save project chat" },
		{ "<leader>aL", "<cmd>CopilotChatProjectLoad<CR>", mode = "n", desc = "Load project chat" },
	},
}
