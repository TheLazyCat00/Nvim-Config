return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		prioriy = 1000,
		opts = function()
			return {
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
						-- Your existing boolean override
						Boolean = { fg = "#89DEE9" },

						StatusLine = { bg = "#2a2a37" },
					}
				end
			}
		end
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "kanagawa-wave",
		},
	}
}
