return {
	"TheLazyCat00/builder-nvim",
	lazy = false,
	opts = {},
	keys = {
		{ "<leader>r" , function ()
			require("builder-nvim").run()
		end, desc = "Run"}
	}
}
