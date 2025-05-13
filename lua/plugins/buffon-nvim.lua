return {
	"francescarpi/buffon.nvim",
	lazy = false,
	branch = "develop",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",

		--- buffon extensions
		{
			"TheLazyCat00/buffon-colors",
			opts = {},
		},
	},
	---@type BuffonConfig
	opts = {
		open = {
			by_default = true,
			offset = {
				x = -3,
				y = 3,
			},
			ignore_ft = {
				"gitcommit",
				"gitrebase",
			},
		},
		num_pages = 1,
		leader_key = "ö",
		mapping_chars = "abcdefgilmnoprstvwy",
		keybindings = {
			toggle_buffon_window = "<buffonleader>u",
			toggle_buffon_window_position = "<buffonleader>z",
			move_buffer_up = "<buffonleader>k",
			move_buffer_down = "<buffonleader>j",
			close_buffers_above = "<buffonleader>K",
			close_buffers_below = "<buffonleader>J",
			show_help = "<buffonleader>h",
			goto_next_buffer = "",
			goto_previous_buffer = "",
			move_buffer_top = "",
			move_buffer_bottom = "",
			switch_previous_used_buffer = "",
			close_buffer = "",
			close_all_buffers = "",
			close_others = "",
			reopen_recent_closed_buffer = "",
			previous_page = "",
			next_page = "",
			move_to_previous_page = "",
			move_to_next_page = "",
		}
	},
}
