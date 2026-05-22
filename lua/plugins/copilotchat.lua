return {
	"CopilotC-Nvim/CopilotChat.nvim",
	enabled = false,
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		"folke/which-key.nvim",
	},
	build = "make tiktoken",
	opts = function()
		local data_dir = vim.fn.stdpath("data"):gsub("/$", "")

		-- Read-only tools (no bash/edit)
		local ro_tools = { "file", "glob", "grep", "gitdiff", "buffer" }
		local all_tools_except_no_schema = {
			"file", "glob", "grep", "gitdiff", "buffer",
			"url", "bash", "edit",
		}

		return {
			model = "mistral-large-latest",
			system_prompt = "Be concise. Get to the point. No fluff.",
			temperature = 0.2,
			ro_tools = ro_tools,
			all_tools_except_no_schema = all_tools_except_no_schema,

			-- Always include selection as context
			resources = { "selection" },

			tools = all_tools_except_no_schema,
			trusted_tools = ro_tools, -- auto-execute only these trusted read-only tools

			window = {
				layout = "horizontal",
				border = "single",
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

			chat_autocomplete = true,

			history_path = data_dir .. "/copilotchat/chats",
			log_path = vim.fn.stdpath("state") .. "/CopilotChat.log",

			instruction_files = { ".github/copilot-instructions.md", "AGENTS.md" },
		}
	end,

	config = function(_, opts)
		-- -----------------------------------------------------------------------
		-- Providers: add Mistral + disable Copilot/GitHub providers
		-- -----------------------------------------------------------------------
		local cfg = require("CopilotChat.config")

		if cfg.providers and cfg.providers.copilot then
			cfg.providers.copilot.disabled = true
		end
		if cfg.providers and cfg.providers.github_models then
			cfg.providers.github_models.disabled = true
		end

		-- Custom Mistral provider (OpenAI-ish chat/completions style)
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
				local response, err = require("CopilotChat.utils.curl").get("https://api.mistral.ai/v1/models", {
					headers = headers,
					json_response = true,
				})
				if err then
					error(err)
				end

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
						-- IMPORTANT: mark these models as tool-capable so CopilotChat will actually send tool schemas
						return {
							id = model.id,
							name = model.name,
							tools = true,
							streaming = true,
						}
					end)
					:totable()
			end,

			get_url = function()
				return "https://api.mistral.ai/v1/chat/completions"
			end,
		}

		-- Start CopilotChat
		local chat = require("CopilotChat")
		chat.setup(opts)
		do
			local client = require("CopilotChat.client")
			local orig_ask = client.ask

			local FLUSH_MS = 400

			client.ask = function(self, ask_opts)
				if ask_opts and ask_opts.on_progress then
					local orig_progress = ask_opts.on_progress
					local pending_content = ""
					local pending_reasoning = ""
					local scheduled = false
					local last_role = nil

					ask_opts.on_progress = function(msg)
						last_role = msg.role or last_role
						pending_content = pending_content .. (msg.content or "")
						pending_reasoning = pending_reasoning .. (msg.reasoning or "")

						if scheduled then
							return
						end
						scheduled = true

						vim.defer_fn(function()
							scheduled = false
							if pending_content ~= "" or pending_reasoning ~= "" then
								orig_progress({
									role = last_role,
									content = pending_content,
									reasoning = pending_reasoning,
								})
								pending_content = ""
								pending_reasoning = ""
							end
						end, FLUSH_MS)
					end
				end

				return orig_ask(self, ask_opts)
			end
		end

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

		vim.api.nvim_create_autocmd("VimLeavePre", { callback = save_project_chat })
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
		-- Prompts (ensure they return edit blocks we can apply)
		-- -----------------------------------------------------------------------
		chat.setup({
			prompts = vim.tbl_extend("force", require("CopilotChat.config.prompts"), {
				Rewrite = {
					description = "Rewrite selection (read-only repo exploration enabled)",
					prompt = table.concat({
						"Rewrite the selected code according to the user's instruction.",
						"You MAY use the available read-only tools (file/glob/grep/gitdiff/buffer) to inspect the codebase before answering.",
						"Only modify the current file/selection.",
						"Return ONLY CopilotChat edit blocks in this format:",
						"```<ft> path=<path> start_line=<n> end_line=<n>",
						"<replacement>",
						"```",
					}, "\n"),
					resources = { "selection" },
					tools = { "file", "glob", "grep", "gitdiff", "buffer" },
				},

				Append = {
					description = "Append to selection",
					prompt = table.concat({
						"Append new code/content to the selected code according to the user's instruction.",
						"You MAY use read-only tools (file/glob/grep/gitdiff/buffer) first.",
						"Only modify the current file/selection.",
						"Return ONLY CopilotChat edit blocks (same format as /Rewrite).",
					}, "\n"),
					resources = { "selection" },
					tools = { "file", "glob", "grep", "gitdiff", "buffer" },
				},

				Prepend = {
					description = "Prepend to selection",
					prompt = table.concat({
						"Prepend new code/content before the selected code according to the user's instruction.",
						"You MAY use read-only tools (file/glob/grep/gitdiff/buffer) first.",
						"Only modify the current file/selection.",
						"Return ONLY CopilotChat edit blocks (same format as /Rewrite).",
					}, "\n"),
					resources = { "selection" },
					tools = { "file", "glob", "grep", "gitdiff", "buffer" },
				},

				FixApply = {
					description = "Fix selection (no explanation; just applyable edit blocks)",
					prompt = table.concat({
						"Fix bugs/issues in the selected code.",
						"You MAY use read-only tools (file/glob/grep/gitdiff/buffer) first.",
						"Only modify the current file/selection.",
						"Return ONLY CopilotChat edit blocks (same format as /Rewrite).",
					}, "\n"),
					resources = { "selection" },
					tools = { "file", "glob", "grep", "gitdiff", "buffer" },
				},
			}),
		})

		-- -----------------------------------------------------------------------
		-- Silent apply workflow (no visible chat, apply result, one undo)
		-- -----------------------------------------------------------------------
		local constants = require("CopilotChat.constants")
		local diff = require("CopilotChat.utils.diff")

		local silent_window = {
			layout = "float",
			relative = "editor",
			width = 1,
			height = 1,
			row = 0,
			col = 0,
			border = "none",
			title = "",
			zindex = 1,
			blend = 100,
		}

		local function match_block_header(header)
			if not header then
				return
			end
			local patterns = {
				"^(%w+)%s+path=(.-)%s+start_line=(%d+)%s+end_line=(%d+)$",
				"^(%w+)%s+path=(%S+)%s+start_line=(%d+)%s+end_line=(%d+)$",
				"^(%w+)$",
			}
			for _, pattern in ipairs(patterns) do
				local ft, path, s, e = header:match(pattern)
				if path then
					return ft, path, tonumber(s) or 1, tonumber(e) or tonumber(s) or 1
				elseif ft then
					return ft, nil, nil, nil
				end
			end
		end

		local function parse_edit_blocks(text)
			local blocks = {}
			local lines = vim.split(text or "", "\n", { plain = true })
			local i = 1

			while i <= #lines do
				local header = lines[i]:match("^```%s*(.-)%s*$")
				if header then
					local ft, path, s, e = match_block_header(header)
					local body = {}
					i = i + 1
					while i <= #lines and not lines[i]:match("^```%s*$") do
						table.insert(body, lines[i])
						i = i + 1
					end

					if ft then
						table.insert(blocks, {
							header = {
								filetype = ft,
								filename = path or "",
								start_line = s,
								end_line = e,
							},
							content = table.concat(body, "\n"),
						})
					end
				end
				i = i + 1
			end

			return blocks
		end

		local function is_busy()
			local bufnr = chat.chat and chat.chat.bufnr
			if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
				return not vim.bo[bufnr].modifiable
			end
			return false
		end

		local function ask_and_apply(prompt)
			local orig_win = vim.api.nvim_get_current_win()
			local was_visible = chat.chat:visible()
			chat.chat:set_source(orig_win)

			local before_assistant = chat.chat:get_message(constants.ROLE.ASSISTANT)
			local before_id = before_assistant and before_assistant.id or nil

			chat.ask(prompt, {
				window = silent_window,
				show_help = false,
				auto_follow_cursor = false,
				tools = opts.ro_tools,
				trusted_tools = opts.ro_tools,
			})

			vim.schedule(function()
				if vim.api.nvim_win_is_valid(orig_win) then
					vim.api.nvim_set_current_win(orig_win)
				end
			end)

			local timeout_ms = 60000
			local step_ms = 40
			local waited = 0

			local function poll()
				waited = waited + step_ms
				if waited > timeout_ms then
					vim.notify("CopilotChat: timed out waiting for response", vim.log.levels.WARN)
					if not was_visible then
						pcall(chat.close)
					end
					return
				end

				if is_busy() then
					vim.defer_fn(poll, step_ms)
					return
				end

				local msg = chat.chat:get_message(constants.ROLE.ASSISTANT)
				if not msg or (before_id and msg.id == before_id) then
					vim.defer_fn(poll, step_ms)
					return
				end

				local blocks = parse_edit_blocks(msg.content or "")
				if #blocks == 0 then
					vim.notify("CopilotChat: no edit blocks found; opening chat for inspection", vim.log.levels.WARN)
					chat.open()
					return
				end

				local source = chat.chat:get_source()
				local bufnr = source.bufnr
				if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
					vim.notify("CopilotChat: invalid source buffer", vim.log.levels.ERROR)
					if not was_visible then
						pcall(chat.close)
					end
					return
				end

				local old_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
				local new_lines = old_lines

				for i = #blocks, 1, -1 do
					new_lines = diff.apply_diff(blocks[i], new_lines)
				end

				local view = nil
				if source.winnr and vim.api.nvim_win_is_valid(source.winnr) then
					view = vim.fn.winsaveview()
				end

				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)

				if view and source.winnr and vim.api.nvim_win_is_valid(source.winnr) then
					pcall(vim.fn.winrestview, view)
				end

				vim.notify("Applied AI edit (press `u` to undo)", vim.log.levels.INFO)

				if not was_visible then
					pcall(chat.close)
				end
			end

			vim.defer_fn(poll, step_ms)
		end

		vim.api.nvim_create_user_command("CopilotChatRewriteApply", function(cmd)
			ask_and_apply("/Rewrite " .. (cmd.args or ""))
		end, { nargs = "*" })

		vim.api.nvim_create_user_command("CopilotChatAppendApply", function(cmd)
			ask_and_apply("/Append " .. (cmd.args or ""))
		end, { nargs = "*" })

		vim.api.nvim_create_user_command("CopilotChatPrependApply", function(cmd)
			ask_and_apply("/Prepend " .. (cmd.args or ""))
		end, { nargs = "*" })

		vim.api.nvim_create_user_command("CopilotChatFixApply", function()
			ask_and_apply("/FixApply")
		end, {})

		vim.api.nvim_create_user_command("CopilotChatRetry", function()
			local last_user = chat.chat:get_message(constants.ROLE.USER, true)
			if last_user and last_user.content and vim.trim(last_user.content) ~= "" then
				chat.ask(last_user.content)
			end
		end, {})
	end,

	keys = {
		{ "<leader>at", "<cmd>CopilotChatToggle<CR>", mode = "n", desc = "Toggle Copilot Chat" },
		{ "<leader>an", "<cmd>CopilotChatProjectNew<CR>", mode = "n", desc = "New Chat (save+reset, per-project)" },

		{ "<leader>ai", ":CopilotChatRewriteApply ", mode = { "n", "x" }, desc = "Rewrite (apply; undo with u)" },
		{ "<leader>aa", ":CopilotChatAppendApply ", mode = { "n", "x" }, desc = "Append (apply; undo with u)" },
		{ "<leader>aS", ":CopilotChatPrependApply ", mode = { "n", "x" }, desc = "Prepend (apply; undo with u)" },
		{ "<leader>ae", "<cmd>CopilotChatFixApply<CR>", mode = { "n", "x" }, desc = "Fix (apply; undo with u)" },

		{ "<leader>ar", "<cmd>CopilotChatRetry<CR>", mode = { "n", "x" }, desc = "Retry last prompt" },
		{ "<leader>aq", "<cmd>CopilotChatStop<CR>", mode = { "n", "x" }, desc = "Stop" },

		{ "<leader>am", "<cmd>CopilotChatModels<CR>", mode = "n", desc = "Select model" },
		{ "<leader>ac", "<cmd>CopilotChatPrompts<CR>", mode = "n", desc = "Prompt picker" },

		{ "<leader>as", "<cmd>CopilotChatProjectSave<CR>", mode = "n", desc = "Save project chat" },
		{ "<leader>aL", "<cmd>CopilotChatProjectLoad<CR>", mode = "n", desc = "Load project chat" },
	},
}
