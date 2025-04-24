return {
	"TheLazyCat00/replace-nvim",
	opts = {},
	keys = {
		{
			"t",
			function() return require('replace-nvim').replace(true) end,
			mode = { "n", "x" },
			expr = true,
			desc = "Replace with clipboard",
		},
	},
}
