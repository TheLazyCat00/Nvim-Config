return {
	"MeanderingProgrammer/render-markdown.nvim",
	opts = {
		render_modes = { 'n', 'c', 't', "i" },
		code = {
			sign = true,
			width = "full",
			right_pad = 1,
			border = "thin"
		},
		heading = {
			sign = false,
		},
	},
	ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
	config = function(_, opts)
		require("render-markdown").setup(opts)
		Snacks.toggle({
			name = "Render Markdown",
			get = function()
				return require("render-markdown.state").enabled
			end,
			set = function(enabled)
				local m = require("render-markdown")
				if enabled then
					m.enable()
				else
					m.disable()
				end
			end,
		}):map("<leader>um")
	end,
}
