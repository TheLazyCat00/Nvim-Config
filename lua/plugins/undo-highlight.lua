return {
	"y3owk1n/undo-glow.nvim",
	version = "*", -- use stable releases
	opts = {
		animation = {
			enabled = true,        -- Turn animations on/off
			duration = 300,        -- How long highlights last (milliseconds)
			animation_type = "fade", -- Animation style (see options below)
		},
	},
	keys = {
		{
			"u",
			function()
				require("undo-glow").undo()
			end,
			mode = "n",
			desc = "Undo with highlight",
			noremap = true,
		},
		{
			"U",
			function()
				require("undo-glow").redo()
			end,
			mode = "n",
			desc = "Redo with highlight",
			noremap = true,
		},
	}
}
