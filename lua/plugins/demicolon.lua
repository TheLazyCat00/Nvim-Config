return {
	"mawkler/demicolon.nvim",
	enabled = false,
	event = "BufReadPost",
	config = function ()
		require("demicolon").setup({})
		local wk = require("which-key")
		wk.add({
			mode = {'n', 'x', 'o'},
			{',', require('demicolon.repeat_jump').next, desc = "Repeat backward"},
			{';', require('demicolon.repeat_jump').prev, desc = "Repeat forward"}
		})
	end
}
