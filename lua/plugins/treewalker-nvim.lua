return {
	'aaronik/treewalker.nvim',
	enabled = false,
	-- The following options are the defaults.
	-- Treewalker aims for sane defaults, so these are each individually optional,
	-- and setup() does not need to be called, so the whole opts block is optional as well.
	opts = {
		-- Whether to briefly highlight the node after jumping to it
		highlight = true,

		-- How long should above highlight last (in ms)
		highlight_duration = 250,

		-- The color of the above highlight. Must be a valid vim highlight group.
		-- (see :h highlight-group for options)
		highlight_group = 'CursorLine',
	},
	keys = {
		{ "<M-k>", "<Cmd>Treewalker Up<cr>", desc = "Treewalker up" },
		{ "<M-j>", "<Cmd>Treewalker Down<cr>", desc = "Treewalker down" },
		{ "<M-h>", "<Cmd>Treewalker Left<cr>", desc = "Treewalker left" },
		{ "<M-l>", "<Cmd>Treewalker Right<cr>", desc = "Treewalker right" },

		{ "<M-K>", "<Cmd>Treewalker SwapUp<cr>", desc = "Treewalker swap up" },
		{ "<M-J>", "<Cmd>Treewalker SwapDown<cr>", desc = "Treewalker swap down" },
		{ "<M-H>", "<Cmd>Treewalker SwapLeft<cr>", desc = "Treewalker swap left" },
		{ "<M-L>", "<Cmd>Treewalker SwapRight<cr>", desc = "Treewalker swap right" },
	}
}
