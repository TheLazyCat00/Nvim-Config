return {
	"TheLazyCat00/sailor-nvim",
	keys = {
		{ "sa", function() require("sailor-nvim").setAnchor() end, desc = "Set anchor" },
		{ "sh", function() require("sailor-nvim").goHome() end, desc = "Go home" },
	}
}
