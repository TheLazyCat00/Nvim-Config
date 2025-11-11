return {
	"catppuccin/nvim",
	enabled = false,
	lazy = false, -- Loads the plugin immediately at startup
	priority = 1000,
	name = "catppuccin",
	opts = {
		flavour = "mocha",
		color_overrides = {
			mocha = {
				mantle = "#383140",
				crust = "#7A3636",
				sky = "#CE6B4D"
			}
		}
	},
}
