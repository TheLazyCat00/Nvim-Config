return {
	"lukas-reineke/indent-blankline.nvim",
	version = "*", -- Use the latest version
	event = "BufReadPre",
	config = function()
		require("ibl").setup {
			indent = {
				tab_char = "▏",
				smart_indent_cap = true
			},
			scope = { enabled = false }, -- Adjust as needed for new options
		}
	end,
}
