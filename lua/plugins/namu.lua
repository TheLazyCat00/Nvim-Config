return {
	"TheLazyCat00/namu.nvim",
	opts = {
		namu_symbols = { -- Specific Module options
			display = { mode = "icon", format = "tree_guides" },
		},
		watchtower = {
			prefer_treesitter = true,
		}
	},
	cmd = "Namu",
	keys = {
		{ "<leader>ss", "<cmd>Namu treesitter<cr>", desc = "Namu treesitter" },
		{ "<leader>sw", "<cmd>Namu watchtower<cr>", desc = "Namu watchtower" }
	}
}
