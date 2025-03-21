return {
	"nvim-telescope/telescope-file-browser.nvim",
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
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
	keys = {
		{ "<leader><space>", "<cmd>Telescope file_browser<CR>", mode = "n", desc = "Open File Browser" }
	},
	config = function (_, opts)
		require("telescope").setup(opts)
	end
}
