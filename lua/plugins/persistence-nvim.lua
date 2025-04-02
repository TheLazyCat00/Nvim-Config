local uv = vim.loop
local nvimData = vim.fn.stdpath("data")
local sessionDir = nvimData .. "/sessions/"

local function getMostRecentSession()
	local mostRecentFile = nil
	local mostRecentTime = 0

	local dir = uv.fs_scandir(sessionDir)
	if not dir then return nil end

	while true do
		local file = uv.fs_scandir_next(dir)
		if not file then break end
		local filePath = sessionDir .. file
		local stat = uv.fs_stat(filePath)
		if stat and stat.mtime.sec > mostRecentTime then
			mostRecentTime = stat.mtime.sec
			mostRecentFile = file
		end
	end

	return mostRecentFile
end

local function cdToSession()
	local sessionFile = getMostRecentSession()
	if not sessionFile then
		vim.notify("No session files found", vim.log.levels.WARN)
		return
	end

	local targetDir = sessionFile:gsub("%%", "/")
	targetDir = targetDir:gsub("^C/", "C:/")
	targetDir = targetDir:gsub("%.vim$", "")
	vim.cmd("cd " .. vim.fn.fnameescape(targetDir))
	vim.notify(targetDir)
end

cdToSession()
return {
	"folke/persistence.nvim",
	event = "UIEnter",
	enabled = vim.g.project_manager == "persistence.nvim",
	opts = {},
	config = function (_, opts)
		require("persistence").setup(opts)
	end,
	keys = function ()
		return {
			{ "sr", function() require("persistence").load() end, desc = "Restore Session" },
			{ "so", function() require("persistence").select() end, desc = "Select Session" },
			{ "sl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
		}
	end,
}
