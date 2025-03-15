return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "classic",
		triggers = {
			{ "<auto>", mode = "nixsotc" },
			{ "s", mode = "n" },
		}
	},
}
