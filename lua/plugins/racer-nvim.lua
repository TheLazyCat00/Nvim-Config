return {
	"TheLazyCat00/racer-nvim",
	opts = {},
	keys = {
		{";", "<cmd>lua require('racer-nvim').prev()<CR>", mode = {"n", "x"}, desc = "Repeat previous"},
		{",", "<cmd>lua require('racer-nvim').next()<CR>", mode = {"n", "x"}, desc = "Repeat next"},
	},
}
