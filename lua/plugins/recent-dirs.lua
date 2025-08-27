return {
	"TheLazyCat00/recent-dirs",
	enabled = vim.g.neovide or false,
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
