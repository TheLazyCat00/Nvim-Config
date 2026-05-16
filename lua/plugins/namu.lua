return {
	"TheLazyCat00/namu.nvim",
	lazy = false,
	opts = {
		namu_symbols = { -- Specific Module options
			display = { mode = "icon", format = "tree_guides" },
			options = {
				AllowKinds = {
					default = {
						"Function",
						-- "Method",
						-- "Class",
						-- "Module",
						-- "Property",
						-- "Variable",
						-- "Constant",
						-- "Enum",
						-- "Interface",
						-- "Field",
						-- "Struct",
					},
				}
			},
			auto_start = {
				enabled = true,
				mode = "treesitter"
			}
		},
		watchtower = {
			prefer_treesitter = true,
			options = {
				AllowKinds = {
					default = {
						"Function",
						-- "Method",
						-- "Class",
						-- "Module",
						-- "Property",
						-- "Variable",
						-- "Constant",
						-- "Enum",
						-- "Interface",
						-- "Field",
						-- "Struct",
					},
				}
			}
		}
	},
	cmd = "Namu",
	keys = {
		{ "<leader>ss", "<cmd>Namu treesitter<cr>", desc = "Namu treesitter" },
		{ "<leader>sw", "<cmd>Namu watchtower<cr>", desc = "Namu watchtower" }
	}
}
