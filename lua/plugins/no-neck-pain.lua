return {
	"shortcuts/no-neck-pain.nvim",
	enabled = false,
	lazy = false,
	version = "*",
	opts = {
		autocmds = {
			enableOnVimEnter = true,
		},
		buffers = {
			left = {
				scratchPad = {
					enabled = true,
					pathToFile = "~/projects/notes.md",
				}
			}
		},
		integrations = {
			dashboard = {
				enabled = true,
			},
		},
	}
}
