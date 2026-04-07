-- INFO: place to put more complex logic

local nvimFiles = {
	["~/.rubocop.yml"] = {
		"Layout/IndentationStyle:",
		"  Enabled: false",
		"Layout/IndentationWidth:",
		"  Enabled: false",
		"Style:",
		"  Enabled: false",
	},
	["~/.config/opencode/opencode.json"] = {
		[[{]],
		[[	"$schema": "https://opencode.ai/config.json",]],
		[[	"permission": {]],
		[[		"*": "allow",]],
		[[		"edit": "ask",]],
		[[		"bash": "ask",]],
		[[		"external_directory": "ask"]],
		[[	}]],
		[[}]],
	}
}

for path, content in pairs(nvimFiles) do
	local expanded = vim.fn.expand(path)
	local f = io.open(expanded, "w")
	if f then
		f:write(type(content) == "table" and table.concat(content, "\n") or content)
		f:close()
	end
end
