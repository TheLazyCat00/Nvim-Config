local uv = vim.uv

local history_path = "tasksHistory.json"

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
	local json_str = vim.fn.json_encode(tbl)

	create_file_if_missing(history_path)

	local fd, err = uv.fs_open(history_path, "w", 420)
	if not fd then
		vim.notify("Failed to open file for writing: " .. history_path .. " (" .. err .. ")", vim.log.levels.ERROR)
		return
	end

	uv.fs_write(fd, json_str)
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

local function append_to_history(task_defn)
	local history = load_json()
	table.insert(history, task_defn)
end

return {
	'TheLazyCat00/overseer.nvim',
	cmd = { "OverseerRun", "OverseerToggle" },
	opts = {},
	config = function (_, opts)
		local overseer = require("overseer")
		overseer.setup(opts)
		overseer.add_template_hook({}, function (task_defn, util)
		end)
	end
}
