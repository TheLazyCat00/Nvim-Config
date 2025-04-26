return {
	"gbprod/substitute.nvim",
	opts = {
		highlight_substituted_text = {
			enabled = false,
		},
	},
	keys = {
		{ "t", function () require('substitute').operator() end },
		{ "tu", function () require('substitute').line() end },
		{ "T", function () require('substitute').eol() end },
		{ "t", function () require('substitute').visual() end, mode = "x" },
	}
}
