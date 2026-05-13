return {
	'TheLazyCat00/fugit2.nvim',
	build = false,
	opts = {
		width = 100,
	},
	dependencies = {
		'MunifTanjim/nui.nvim',
		'nvim-tree/nvim-web-devicons',
		'nvim-lua/plenary.nvim',
		'chrisgrieser/nvim-tinygit',
	},
	cmd = { 'Fugit2', 'Fugit2Diff', 'Fugit2Graph', 'Fugit2Rebase' },
	keys = {
		{ '<leader>z', mode = 'n', '<cmd>Fugit2<cr>' }
	}
}
