return {
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		event = "UIEnter",
		keys = {
			{"<leader><space>", "<cmd>Telescope file_browser<CR>", mode = "n", desc = "Open File Browser"}
		}
	},
	{
		"nvim-telescope/telescope.nvim",
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
					display_stat = false
				}
			}
		}
	}
}
