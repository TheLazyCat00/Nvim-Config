return {
	"folke/persistence.nvim",
	event = "UIEnter",
	enabled = vim.g.project_manager == "persistence.nvim",
	opts = {},
	keys = function ()
		return {
			{ "sr", function() require("persistence").load() end, desc = "Restore Session" },
			{ "so", function() require("persistence").select() end, desc = "Select Session" },
			{ "sl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
		}
	end,
}
