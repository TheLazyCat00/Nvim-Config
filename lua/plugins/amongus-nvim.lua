return {
	"TheLazyCat00/amongus-nvim",
	enabled = false,
	opts = {},
	keys = {
		{ "<M-h>", function ()
			require("amongus-nvim").prevSibling()
		end, desc = "Amongus prev sibling" },
		{ "<M-l>", function ()
			require("amongus-nvim").nextSibling()
		end, desc = "Amongus next sibling" },
		{ "<M-k>", function ()
			require("amongus-nvim").prevGroup()
		end, desc = "Amongus prev group" },
		{ "<M-j>", function ()
			require("amongus-nvim").nextGroup()
		end, desc = "Amongus next group" },
	}
}
