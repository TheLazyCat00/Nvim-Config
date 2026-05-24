return {
	"sudo-tee/opencode.nvim",
	enabled = false,
	lazy = false,
	opts = {
		default_system_prompt = "Be concise. Get to the point. No fluff.",
		keymap_prefix = '<leader>a',
		keymap = {
			input_window = {
				['<esc>'] = false,
				['<cr>'] = false,
				['<S-cr>'] = false,
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
		"MeanderingProgrammer/render-markdown.nvim",
		'saghen/blink.cmp',
		'folke/snacks.nvim',
	},
	init = function ()
		vim.api.nvim_create_autocmd("DirChanged", {
			callback = function ()
				local state = require('opencode.state')
				if state.opencode_server then
					state.opencode_server:shutdown()
				end
			end
		})
	end
}
