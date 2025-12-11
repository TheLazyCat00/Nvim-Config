return {
	"TheLazyCat00/runner-nvim",
	opts = {},
	keys = {
		{ "<leader>r", function () require("runner-nvim").runLast() end, desc = "Run last cmd" },
		{ "<leader>o", function () require("runner-nvim").run() end, desc = "Run cmd" },
		{ "<leader>t", function () require("runner-nvim").toggle() end, desc = "Toggle terminal"},
	}
}
