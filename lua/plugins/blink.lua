return {
	"saghen/blink.cmp",
	enabled = vim.g.lazyvim_cmp == "blink.cmp",
	opts = function(_, opts)
		vim.tbl_extend("force", opts, {
			appearance = {
				kind_icons = vim.deepcopy(LazyVim.config.icons.kinds)
			},
			fuzzy = {
				implementation = "prefer_rust_with_warning",
			},
			sources = {
				providers = {
					snippets = {
						-- defaults:
						-- lsp: 0
						-- snippets: -1
						-- path: 3
						-- buffer: -3
						score_offset = -0.2
					}
				}
			},
			keymap = {
				preset = "enter",
				['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
				['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
			},
		})
	end
}
