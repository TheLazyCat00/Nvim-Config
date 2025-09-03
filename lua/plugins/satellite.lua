return {
	"lewis6991/satellite.nvim",
	event = "BufReadPre",
	enabled = false, -- might be the cause of lags in large files
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
