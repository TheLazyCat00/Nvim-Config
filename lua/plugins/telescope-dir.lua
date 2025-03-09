return {
	"nvim-telescope/telescope-file-browser.nvim",
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	priority = 100,
	lazy = false,
	config = function()
		vim.keymap.set("n", "<leader><space>", ":Telescope file_browser<CR>")
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
