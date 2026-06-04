return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function(_, opts)
		local mc = require("multicursor-nvim")
		mc.setup(opts)

		mc.addKeymapLayer(function(layerSet)
			layerSet("n", "gl", mc.alignCursors)
			layerSet("n", "<esc>", function()
				if mc.hasCursors() then
					mc.clearCursors()
				end
			end)
			layerSet({"n", "x"}, "H", mc.prevCursor)
			layerSet({"n", "x"}, "L", mc.nextCursor)
		end)
	end,
	init = function ()
		local hl = vim.api.nvim_set_hl
		hl(0, "MultiCursorCursor", { reverse = true })
		hl(0, "MultiCursorVisual", { link = "Visual" })
		hl(0, "MultiCursorSign", { link = "SignColumn"})
		hl(0, "MultiCursorMatchPreview", { link = "Search" })
		hl(0, "MultiCursorDisabledCursor", { reverse = true })
		hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
	end,
	keys = {
		{"<M-k>",function()
			require("multicursor-nvim").lineAddCursor(-1)
		end, mode = {"n", "x"}},
		{"<M-j>", function()
			require("multicursor-nvim").lineAddCursor(1)
		end, mode = {"n", "x"}},
		{"<M-l>", function()
			require("multicursor-nvim").matchAddCursor(1)
		end, mode = {"n", "x"}},
		{"<M-h>", function()
			require("multicursor-nvim").matchAddCursor(-1)
		end, mode = {"n", "x"}},
		{"s", function ()
			require("multicursor-nvim").splitCursors()
		end, mode = "x"},

		{"*", function() require("multicursor-nvim").matchAllAddCursors() end, mode = {"n", "x"}},
	}
}
