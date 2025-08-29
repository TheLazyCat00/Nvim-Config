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
	local indent_level = 0
	local in_string = false
	for i = 1, #json_str do
		local char = json_str:sub(i, i)
		if char == '"' and (i == 1 or json_str:sub(i - 1, i - 1) ~= "\\") then
			in_string = not in_string
		end

		if not in_string then
			if char == "{" or char == "[" then
				indent_level = indent_level + 1
				pretty_json = pretty_json .. char .. "\n" .. string.rep("\t", indent_level)
			elseif char == "}" or char == "]" then
				indent_level = indent_level - 1
				pretty_json = pretty_json .. "\n" .. string.rep("\t", indent_level) .. char
			elseif char == "," then
				pretty_json = pretty_json .. char .. "\n" .. string.rep("\t", indent_level)
			elseif char == ":" then
				pretty_json = pretty_json .. char .. " "
			elseif char ~= " " and char ~= "\n" and char ~= "\r" then
				pretty_json = pretty_json .. char
			end
		else
			pretty_json = pretty_json .. char
		end
	end

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
	local has_numeric_keys = false
	local has_string_keys = false
	local numeric_keys = {}
	for k, _ in pairs(tbl) do
		if type(k) == "number" then
			has_numeric_keys = true
			table.insert(numeric_keys, k)
		elseif type(k) == "string" then
			has_string_keys = true
		end
	end
	table.sort(numeric_keys)

	if has_numeric_keys and has_string_keys then
		-- Mixed table, convert to object
		local is_component = false
		if #numeric_keys == 1 and numeric_keys[1] == 1 and type(tbl[1]) == "string" then
			sanitized_tbl["name"] = tbl[1]
			is_component = true
		end
		for k, v in pairs(tbl) do
			if type(k) == "string" then
				sanitized_tbl[k] = sanitize_for_json(v)
			elseif not is_component then
				-- Handle non-component mixed tables if necessary
				sanitized_tbl[tostring(k)] = sanitize_for_json(v)
			end
		end
	elseif has_numeric_keys then
		-- Array-like table
		for _, k in ipairs(numeric_keys) do
			table.insert(sanitized_tbl, sanitize_for_json(tbl[k]))
		end
	else
		-- Object-like table
		for k, v in pairs(tbl) do
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

return {
	'TheLazyCat00/overseer.nvim',
	cmd = { "OverseerRun", "OverseerToggle" },
	opts = {},
	config = function (_, opts)
		local overseer = require("overseer")
		overseer.setup(opts)
		overseer.add_template_hook({}, function (task_defn, util)
			append_to_history(task_defn)
		end)
	end
}
