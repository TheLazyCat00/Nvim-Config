return {
	"roobert/tabtree.nvim",
	opts = {
		default_config = {
			target_query = [[
				value: (_) @value
				arguments: (_) @arguments
				parameters: (_) @parameters
			]],
			offsets = {},
		}
	},
	keys = {
		{"<Tab>", "<cmd>lua require('tabtree').next()<CR>", mode = "n", desc = "Tabtree next"},
		{"<S-Tab>", "<cmd>lua require('tabtree').prev()CR>", mode = "n", desc = "Tabtree prev"}
	}
}
