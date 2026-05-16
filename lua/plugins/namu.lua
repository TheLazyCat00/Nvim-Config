return {
	"bassamsdata/namu.nvim",
	opts = {
		namu_symbols = { -- Specific Module options
			display = { mode = "icon", format = "tree_guides" },
		},
	},
	cmd = "Namu",
	keys = {
		{ "<leader>ss", "<cmd>Namu symbols<cr>", desc = "Jump to LSP symbol" },
		{ "<leader>sw", "<cmd>Namu workspace<cr>", desc = "LSP Symbols - Workspace" }
	}
}
