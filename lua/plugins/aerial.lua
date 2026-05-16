return {
	'stevearc/aerial.nvim',
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons"
	},
	lazy = false,
	opts = {
		layout = {
			width = 0.2,

			-- key-value pairs of window-local options for aerial window (e.g. winhl)
			win_opts = {},

			default_direction = "left",

			-- Determines where the aerial window will be opened
			--   edge   - open aerial at the far right/left of the editor
			--   window - open aerial to the right/left of the current window
			placement = "edge",

			-- When the symbols change, resize the aerial window (within min/max constraints) to fit
			resize_to_content = false,

			-- Preserve window size equality with (:help CTRL-W_=)
			preserve_equality = false,
		},
		ignore = {
			unlisted_buffers = true,
		},
		attach_mode = "global",
		open_automatic = true,
	},
	keys = {
		{ "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
	},
}
