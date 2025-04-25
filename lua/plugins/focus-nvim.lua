return {
	"TheLazyCat00/focus-nvim",
	lazy = false,
	opts = {},
	keys = {
		{
			"l",
			function () require("focus-nvim").open("l") end,
			desc = "Right"
		}
	}
}
