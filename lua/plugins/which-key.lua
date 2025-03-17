return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "classic",
		spec = {
			{
				mode = "n",
				{ "<leader>q", group = false },
			}
		},
		triggers = {
			{ "<auto>", mode = "nixsotc" },
			{ "s", mode = "n" },
		}
	},
}
