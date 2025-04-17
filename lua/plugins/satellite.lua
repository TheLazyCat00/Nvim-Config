return {
	"lewis6991/satellite.nvim",
	event = "BufReadPre",
	opts = {
		handlers = {
			marks = {
				enable = false,
			},
		}
	},
	init = function ()
		vim.cmd("highlight link SatelliteBar PmenuThumb")
	end
}
