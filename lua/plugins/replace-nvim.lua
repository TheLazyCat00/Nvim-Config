return {
	"TheLazyCat00/replace-nvim",
	opts = {},
	keys = {
		{ "t", function()
			return require('replace-nvim').replace()
		end, expr = true, desc = "Replace with clipboard" }
	}
}
