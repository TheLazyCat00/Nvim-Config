return {
	'Wansmer/treesj',
	dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
	opts = {
		use_default_keymaps = false,
		max_join_length = 500,
	},
	keys = {
		{ "gs", "<cmd>lua require('treesj').toggle()<CR>", mode = "n", desc = "Toggle split/join" },
	}
}
