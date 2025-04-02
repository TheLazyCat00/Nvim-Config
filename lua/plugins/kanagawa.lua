return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	prioriy = 1000,
	opts = {
		theme = "wave",
		background = {
			dark = "wave",
		},
		colors = {
			theme = {
				all = {
					ui = {
						bg_gutter = "none"
					}
				}
			}
		},
		overrides = function(colors)
			return {
				Boolean = { fg = "#38d5ea" },
			}
		end
	},
}
