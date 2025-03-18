return {
	"nvim-telescope/telescope-file-browser.nvim",
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	event = "UIEnter",
	config = function()
		local wk = require("which-key")
		
		wk.add({
			mode = "n",
			{"<leader><space>", ":Telescope file_browser<CR>", desc = "Open File Browser"}
		})
		require("telescope").setup({
			extensions = {
				file_browser = {
					mappings = {
						["i"] = {
							["<bs>"] = false
						},
					},
					depth = 4,
					auto_depth = true,
					no_ignore = true,
				}
			}
		})
	end
}
