return {
	"sudo-tee/opencode.nvim",
	lazy = false,
	opts = {
		keymap_prefix = '<leader>a',
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				anti_conceal = { enabled = false },
				file_types = { 'markdown', 'opencode_output' },
			},
			ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
		},
		'saghen/blink.cmp',
		'folke/snacks.nvim',
	},
}
