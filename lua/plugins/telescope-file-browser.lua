return {
	"nvim-telescope/telescope-file-browser.nvim",
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	event = "UIEnter",
	opts = {
		extensions = {
			file_browser = {
				mappings = {
					["i"] = {
						["<bs>"] = false
					},
				},
				depth = 3,
				auto_depth = true,
				no_ignore = true,
				display_stat = false,
			}
		}
	},
	config = function (_, opts)
		require("telescope").setup(opts)
		local wk = require("which-key")
		wk.add({
			mode = "n",
			{ "<leader><space>", "<cmd>Telescope file_browser<CR>", desc = "Open File Browser" }
		})
	end
}
