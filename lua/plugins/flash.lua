return {
	"folke/flash.nvim",
	vscode = false,
	---@type Flash.Config
	keys = {
		{ "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
		{ "s", mode = { "n", "x", "o" }, false},
		{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
		{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
		{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
	},
	opts = {
		modes = {
			char = {
				keys = { "f", "F", ";", "," },
			}
		}
	}
}
