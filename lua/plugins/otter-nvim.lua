local filetypes = { "markdown" }

vim.api.nvim_create_autocmd("FileType", {
	pattern = filetypes,
	callback = function (args)
		require("otter").activate()
		local bufnr = args.buf
		vim.api.nvim_create_autocmd("BufWritePost", {
			buffer = bufnr,
			callback = function ()
				vim.notify("hi", vim.log.levels.DEBUG)
				require("otter").activate()
			end
		})
	end
})

return {
	"jmbuhr/otter.nvim",
	ft = filetypes,
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
	},
	opts = {},
}
