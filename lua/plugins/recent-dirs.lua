return {
	"TheLazyCat00/recent-dirs",
	event = "UIEnter",
	config = function ()
		require("recent-dirs").load_recent()
	end,
	dependencies= {
		"folke/snacks.nvim"
	},
	keys = {
		{ "so", function ()
			require("recent-dirs").pick()
		end, desc = "Open session" }
	}
}
