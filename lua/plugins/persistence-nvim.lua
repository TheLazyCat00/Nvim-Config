return {
	"folke/persistence.nvim",
	event = "UIEnter",
	enabled = true,
	opts = {},
	keys = function ()
		return {
			{ "so", function() require("persistence").select() end, desc = "Select Session" },
		}
	end,
}
