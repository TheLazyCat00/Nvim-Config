return {
	'TheLazyCat00/fugit2.nvim',
	build = false,
	opts = {
		width = 100,
		file_tree_maps = {
			menu = {
				commit = "C",
				diff = "D",
				branch = "B",
				push = "P",
				fetch = "F",
				pull = "T",
				forge = "N",
				stash = "z",
				cherry_pick = "A",
			},
			direct = {
				commit = "c",
				diff = "d",
				branch = "b",
				push = "p",
				pull = "t",
				fetch = "f",
			},
		},
	},
	dependencies = {
		'MunifTanjim/nui.nvim',
		'nvim-tree/nvim-web-devicons',
		'nvim-lua/plenary.nvim',
		'chrisgrieser/nvim-tinygit',
	},
	cmd = { 'Fugit2', 'Fugit2Diff', 'Fugit2Graph', 'Fugit2Rebase' },
	keys = {
		{ '<leader>z', mode = 'n', '<cmd>Fugit2<CR>', desc = 'Open Fugit2' },
		{ '<leader>gg', mode = 'n', '<cmd>Fugit2Graph<CR>', desc = 'Open Fugit2 Graph' },
	}
}
