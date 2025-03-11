local uv = vim.loop
local templatesDir = vim.fn.stdpath("config") .. "/skeleton"

local function transformFilename(filename)
	return filename:gsub("%-%-", "\1"):gsub("%-", "*"):gsub("\1", "-")
end

local function reverseTransform(filename)
	return filename:gsub("%-", "\1"):gsub("%*", "-"):gsub("\1", "--")
end

local function getFilesInDir(path)
	local files = {}
	local dir = uv.fs_scandir(path)
	if not dir then return files end

	while true do
		local name = uv.fs_scandir_next(dir)
		if not name then break end
		files[transformFilename(name)] = name
	end
	return files
end

return {
	"motosir/skel-nvim",
	event = "VeryLazy",
	opts = {
		templates_dir = templatesDir,
		mappings = getFilesInDir(templatesDir),
		transformFilename = transformFilename,
		reverseTransform = reverseTransform
	}
}
