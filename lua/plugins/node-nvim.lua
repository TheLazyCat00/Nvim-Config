return {
	"TheLazyCat00/node-nvim",
	keys = {
		{ "m", function() require("node-nvim").getCurrentNode() end, desc = "Node under cursor", mode = "o" },
		{ "m", function() require("node-nvim").getCurrentNodeVisual() end, desc = "Node under cursor", mode = "x" },
	}
}
