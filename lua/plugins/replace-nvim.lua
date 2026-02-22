local operatorOpts = {
	modifiers = function(state)
		if state.vmode == "line" then
			return {"reindent"}
		else
			return {"trim"}
		end
	end,
}

return {
	"gbprod/substitute.nvim",
	opts = {
		highlight_substituted_text = {
			enabled = false,
		},
	},
	keys = {
		{ "t", function () require('substitute').operator(operatorOpts) end },
		{ "tu", function () require('substitute').line(operatorOpts) end },
		{ "T", function () require('substitute').eol(operatorOpts) end },
		{ "t", function () require('substitute').visual(operatorOpts) end, mode = "x" },
	}
}
