return {
	'TheLazyCat00/gitstatus.nvim',
	dependencies = {
		'nvim-tree/nvim-web-devicons', -- displays filetype icons
	},
	keys = {
		{ '<leader>z', vim.cmd.Gitstatus }
	}
}
