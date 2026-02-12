return {
    "TheLazyCat00/atone.nvim",
    cmd = "Atone",
    opts = {
		layout = {
			direction = "right",
			width = "adaptive"
		},
		diff_cur_node = {
			enabled = true,
			split_percent = 0.3,
			width = "adaptive"
		},
	},
	keys = {
		{ "<leader>cu", "<Cmd>Atone toggle<CR>", "Toggle undotree"}
	}
}
