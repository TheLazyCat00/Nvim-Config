return {
	"TheLazyCat00/runner-nvim",
	opts = {},
	keys = {
		{ "<leader>r", function () require("runner-nvim").runLast() end },
		{ "<leader>or", function () require("runner-nvim").run() end },
		{ "<leader>ot", function () require("runner-nvim").toggle() end },
	}
}
