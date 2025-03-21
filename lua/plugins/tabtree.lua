return {
	"roobert/tabtree.nvim",
	opts = {
		default_config = {
			target_query = [[
				value: (_) @value
				arguments: (_ 
					(_) @arguments)
				name: (_) @name
			]],
			offsets = {},
		}
	},
	keys = {
		{"<Tab>", "<cmd>lua require('tabtree').next()<CR>", mode = "n", desc = "Tabtree next"},
		{"<S-Tab>", "<cmd>lua require('tabtree').prev()CR>", mode = "n", desc = "Tabtree prev"}
	}
}
