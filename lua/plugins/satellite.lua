return {
	"lewis6991/satellite.nvim",
	event = "BufReadPre",
	opts = {},
	init = function ()
		vim.cmd("highlight link SatelliteBar PmenuThumb")
	end
}
