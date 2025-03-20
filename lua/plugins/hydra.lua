return {
	"https://github.com/nvimtools/hydra.nvim",
	lazy = false,
	event = "VeryLazy",
	config = function ()
		print("hi")
		require("hydra").setup({})
		local hydra = require("hydra")
		hydra({
			name = "test",
			mode = "n",
			body = "z",
			heads = {
				{"l", "zl", {}}
			}
		})
	end
}
