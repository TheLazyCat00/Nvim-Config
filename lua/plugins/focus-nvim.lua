return {
	"TheLazyCat00/focus-nvim",
	event = "BufReadPost",
	opts = {
		languages = {
			["cs"] = [[
				(method_declaration) @func
				(constructor_declaration) @func
				(operator_declaration) @func
			]],
			["lua"] = "(function_declaration) @func",
		},
	},
	keys = {
		{
			"l",
			function () require("focus-nvim").open("l") end,
			desc = "Right"
		}
	}
}
