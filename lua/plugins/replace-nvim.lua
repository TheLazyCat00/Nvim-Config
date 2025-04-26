return {
	"gbprod/substitute.nvim",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		highlight_substituted_text = {
			enabled = false,
			timer = 500,
		},
	},
	keys = {
		{ "t", function () require('substitute').operator() end },
		{ "tu", function () require('substitute').line() end },
		{ "T", function () require('substitute').eol() end },
		{ "t", function () require('substitute').visual() end, mode = "x" },
	}
}
