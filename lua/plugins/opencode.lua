vim.api.nvim_create_autocmd("DirChanged", {
	callback = function ()
		local state = require('opencode.state')
		if state.opencode_server then
			state.opencode_server:shutdown()
		end
	end
})

return {
	"sudo-tee/opencode.nvim",
	lazy = false,
	opts = {
		keymap_prefix = '<leader>a',
		keymap = {
			input_window = {
				['<esc>'] = false,
				['<C-s>'] = { 'submit_input_prompt', mode = { 'n', 'i' } }
			},
			output_window = {
				['<esc>'] = false,
			}
		},
		context = {
			cursor_data = {
				enabled = false,
				context_lines = 5,
			},
			diagnostics = {
				enabled = false,
				info = false,
				warn = true,
				error = true,
			},
			current_file = {
				enabled = false,
				show_full_path = true,
			},
		}
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
