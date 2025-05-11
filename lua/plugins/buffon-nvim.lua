
return {
	"TheLazyCat00/buffon",
	-- event = "BufReadPost",
	lazy = false,
	branch = "main",
	---@type BuffonConfig
	opts = {
		open = {
			by_default = true,
			-- position = "top_right",
			-- offset = {
			-- 	x = -3,
			-- 	y = 3,
			-- },
			ignore_ft = {
				"gitcommit",
				"gitrebase",
			},
		},
		num_pages = 1,
		leader_key = "ö",
		-- colors = {
		-- 	fallback = "normal", -- hl group to use as fallback
		-- 	a = "#00FFFF", -- aqua
		-- 	b = "#0000FF", -- blue
		-- 	c = "#6495ED", -- cornflowerblue
		-- 	d = "#A9A9A9", -- darkgray
		-- 	e = "#C2B280", -- ecru
		-- 	f = "#FF00FF", -- fuchsia
		-- 	g = "#008000", -- green
		-- 	h = "#FF69B4", -- hotpink
		-- 	i = "#4B0082", -- indigo
		-- 	k = "#F0E68C", -- khaki
		-- 	l = "#00FF00", -- lime
		-- 	m = "#800000", -- maroon
		-- 	n = "#000080", -- navy
		-- 	o = "#FFA500", -- orange
		-- 	p = "#800080", -- purple
		-- 	r = "#FF0000", -- red
		-- 	s = "#C0C0C0", -- silver
		-- 	t = "#008080", -- teal
		-- 	v = "#EE82EE", -- violet
		-- 	w = "#FFFFFF", -- white
		-- 	y = "#FFFF00", -- yellow
		-- 	--- missing:
		-- 	--- j, q, u, x, z
		-- },
		mapping_chars = "abcdefgilmnoprstvwy",
		keybindings = {
			toggle_buffon_window = "<buffonleader>u",
			toggle_buffon_window_position = "<buffonleader>z",
			move_buffer_up = "<buffonleader>k",
			move_buffer_down = "<buffonleader>j",
			close_buffers_above = "<buffonleader>K",
			close_buffers_below = "<buffonleader>J",
			show_help = "<buffonleader>h",
			-- goto_next_buffer = "",
			-- goto_previous_buffer = "",
			-- move_buffer_top = "",
			-- move_buffer_bottom = "",
			-- switch_previous_used_buffer = "",
			-- close_buffer = "",
			-- close_all_buffers = "",
			-- close_others = "",
			-- reopen_recent_closed_buffer = "",
			-- previous_page = "",
			-- next_page = "",
			-- move_to_previous_page = "",
			-- move_to_next_page = "",
		}
	},
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
	},
}
