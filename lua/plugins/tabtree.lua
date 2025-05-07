return {
	"roobert/tabtree.nvim",
	enabled = false,
	opts = {
		default_config = {
			target_query = [[
				value: (_) @value
				arguments: (_ 
					(_) @argument)
			]],
			offsets = {},
		}
	},
	keys = {
		{"<Tab>", "<cmd>lua require('tabtree').next()<CR>", mode = {"n", "x"}, desc = "Tabtree next"},
		{"<S-Tab>", "<cmd>lua require('tabtree').prev()CR>", mode = {"n", "x"}, desc = "Tabtree prev"}
	}
}
