return {
	"catppuccin/nvim",
	enabled = false,
	lazy = false, -- Loads the plugin immediately at startup
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			color_overrides = {
				mocha = {
					mantle = "#383140",
					crust = "#7A3636",
					sky = "#CE6B4D"
				}
			}
		})
		vim.cmd("colorscheme catppuccin")
	end
}
