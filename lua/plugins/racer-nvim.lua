return {
	"TheLazyCat00/racer-nvim",
	event = "VeryLazy",
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
		{";", function() require('racer-nvim').prev() end, mode = {"n", "x"}, desc = "Repeat previous"},
		{",", function() require('racer-nvim').next() end, mode = {"n", "x"}, desc = "Repeat next"},
	},
}
