return {
	'Wansmer/treesj',
	event = "BufReadPost",
	dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
	opts = {
		max_join_length = 500,
	},
	keys = {
		{ "m", "<cmd>lua require('treesj').toggle()<CR>", mode = "n", desc = "Toggle split/join" }
	}
}
