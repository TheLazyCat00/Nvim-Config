return {
	{
		"rebelot/kanagawa.nvim",
		enabled = true,
		lazy = false,
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
