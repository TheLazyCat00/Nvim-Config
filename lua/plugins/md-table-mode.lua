return {
	'Kicamon/markdown-table-mode.nvim',
	ft = "markdown",
	opts = {},
	config = function()
		require('markdown-table-mode').setup()
		vim.cmd("Mtm")
	end
}
