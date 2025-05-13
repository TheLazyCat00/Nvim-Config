return {
	"chentoast/marks.nvim",
	event = "VeryLazy",
	opts = {
		default_mappings = false,
		mappings = {}
	},
	keys = {
		{ "m", function () require("marks").set() end, desc = "Set mark" },
		{ "md", function () require("marks").delete_line() end, desc = "Delete mark" },
		{ "mp", function () require("marks").preview() end, desc = "Preview mark" },
		{ "]m", function () require("marks").next() end, desc = "Next mark" },
		{ "[m", function () require("marks").prev() end, desc = "Prev mark" },
	}
}
