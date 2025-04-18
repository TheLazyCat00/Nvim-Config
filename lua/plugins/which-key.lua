return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		spec = {},
		triggers = {
			{ "<auto>", mode = "nixsotc" },
			{ "s", mode = "n" },
		}
	},
}
