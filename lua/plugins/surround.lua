return {
	"kylechui/nvim-surround",
	enabled = false,
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	opts = {
		keymaps = {
			insert = false, -- Disable Insert mode keybinding
			normal = "öö", -- Add surround in Normal mode
			delete = "öc", -- Delete surrounding
			change = "öd", -- Change surrounding
		},
	},
}
