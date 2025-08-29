local uv = vim.uv

local history_path = vim.fn.stdpath("data") .. "/tasksHistory.json"

--- Ensure a file exists, creating parent dirs and optionally initializing it
--- @param path string: Full path to the file
--- @param init_content string|nil: Optional content for initialization
local function create_file_if_missing(path, init_content)
	init_content = init_content or ""

	-- Ensure parent directory exists
	local dir = vim.fn.fnamemodify(path, ":h")
	if uv.fs_stat(dir) == nil then
		vim.fn.mkdir(dir, "p")
	end

	-- Create file if it doesn’t exist
	if uv.fs_stat(path) == nil then
		local fd, err = uv.fs_open(path, "w", 420)
		if not fd then
			vim.notify("Failed to create file: " .. path .. " (" .. err .. ")", vim.log.levels.ERROR)
			return
		end
		uv.fs_write(fd, init_content)
		uv.fs_close(fd)
	end
end

--- @param tbl table: Lua table to save
local function save_table(tbl)
	local json_str = vim.json.encode(tbl)
	-- Pretty-print JSON
	local pretty_json = ""
	local ok, pretty = pcall(vim.fn.system, { "jq", "." }, json_str)
	local pretty_json = (ok and pretty) or json_str

	create_file_if_missing(history_path)

	local fd, err = uv.fs_open(history_path, "w", 420)
	if not fd then
		vim.notify("Failed to open file for writing: " .. history_path .. " (" .. err .. ")", vim.log.levels.ERROR)
		return
	end

	uv.fs_write(fd, pretty_json)
	uv.fs_close(fd)
end

--- @return table
local function load_json()
	if uv.fs_stat(history_path) == nil then
		return {}
	end

	local fd = uv.fs_open(history_path, "r", 420)
	if not fd then return {} end

	local stat = uv.fs_fstat(fd)
	if not stat then return {} end

	local data = uv.fs_read(fd, stat.size, 0)
	uv.fs_close(fd)

	return vim.fn.json_decode(data)
end

local function sanitize_for_json(tbl)
	if type(tbl) ~= "table" then return tbl end

	local sanitized_tbl = {}
	-- Process array part
	for i = 1, #tbl do
		sanitized_tbl[i] = sanitize_for_json(tbl[i])
	end
	-- Process hash part
	for k, v in pairs(tbl) do
		if type(k) == "string" then
			sanitized_tbl[k] = sanitize_for_json(v)
		end
	end

	return sanitized_tbl
end

local function append_to_history(task_defn)
	local history = load_json()

	local sanitized_task = sanitize_for_json(task_defn)

	local cwd = vim.fn.getcwd():gsub("\\", "/")
	if history[cwd] then
		-- Remove existing identical task if present before re-adding to the front
		for i, existing_task in ipairs(history[cwd]) do
			if existing_task.cmd == sanitized_task.cmd then
				table.remove(history[cwd], i)
				break
			end
		end

		table.insert(history[cwd], 1, sanitized_task)
	else
		history[cwd] = { sanitized_task }
	end

	save_table(history)
end

local function run_last_task()
	local history = load_json()
	local cwd = vim.fn.getcwd():gsub("\\", "/")
	if history[cwd] and #history[cwd] > 0 then
		local overseer = require("overseer")
		local task = overseer.new_task(history[cwd][1])
		task:start()
	else
		vim.notify("No previous tasks found for this project", vim.log.levels.WARN)
	end
end

return {
	'stevearc/overseer.nvim',
	cmd = { "OverseerRun", "OverseerToggle" },
	opts = {
		task_list = {
			bindings = {
				["?"] = "ShowHelp",
				["<CR>"] = "RunAction",
				["<C-e>"] = "Edit",
				["<C-v>"] = "OpenVsplit",
				["<C-s>"] = "OpenSplit",
				["<C-f>"] = "OpenFloat",
				["<C-q>"] = "OpenQuickFix",
				["p"] = "TogglePreview",
				["<C-l>"] = "IncreaseDetail",
				["<C-h>"] = "DecreaseDetail",
				["L"] = "IncreaseAllDetail",
				["H"] = "DecreaseAllDetail",
				["["] = "DecreaseWidth",
				["]"] = "IncreaseWidth",
				["{"] = "PrevTask",
				["}"] = "NextTask",
				["<C-k>"] = "ScrollOutputUp",
				["<C-j>"] = "ScrollOutputDown",
				["q"] = "Close",
			},
		}
	},
	config = function (_, opts)
		local overseer = require("overseer")
		overseer.setup(opts)
		overseer.add_template_hook({}, function (task_defn, util)
			append_to_history(task_defn)
		end)

		vim.api.nvim_create_autocmd('User', {
			pattern = 'OverseerListTaskHover',
			callback = function()
				vim.keymap.set("n", "d", "<cmd>OverseerQuickAction dispose<cr>", { desc = "Dispose Task", buffer = true, silent = true })
			end,
		})
	end,
	keys = {
		{ "<leader>r", run_last_task, desc = "Run Last Task" },
		{ "<leader>tr", "<cmd>OverseerRun<cr>", desc = "Run Task" },
		{ "<leader>tt", "<cmd>OverseerToggle<cr>", desc = "Toggle Task List" },
	},
}
