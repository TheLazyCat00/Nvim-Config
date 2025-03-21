return {
	"TheLazyCat00/racer-nvim",
	event = "BufReadPost",
	opts = {
		triggers = {
			{"[", "]"},
			{"F", "f"},
		},
		external = {
			["f"] = require("flash.plugins.char").next,
			["F"] = require("flash.plugins.char").prev,
		}
	},
	keys = {
		{";", "<cmd>lua require('racer-nvim').prev()<CR>", mode = {"n", "x"}, desc = "Repeat previous"},
		{",", "<cmd>lua require('racer-nvim').next()<CR>", mode = {"n", "x"}, desc = "Repeat next"},
	},
}
