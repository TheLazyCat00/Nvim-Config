return {
	"cshuaimin/ssr.nvim",
	opts = {
		border = "rounded",
		min_width = 50,
		min_height = 10,
		max_width = 120,
		max_height = 25,
		adjust_window = true,
		keymaps = {
			close = "q",
			next_match = "n",
			prev_match = "N",
			replace_confirm = "<cr>",
			replace_all = "<leader><cr>",
		},
	},
	keys = {
		{ "<leader>ss", function() require("ssr").open() end, mode = { "n", "x" }, desc = "Structural Search and Replace" },
	},
}
