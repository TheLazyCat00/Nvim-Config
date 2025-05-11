return {
	"folke/persistence.nvim",
	event = "UIEnter",
	enabled = false,
	opts = {},
	keys = function ()
		return {
			-- { "so", function() require("persistence").select() end, desc = "Select Session" },
		}
	end,
}
