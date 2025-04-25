local filetypes = { "markdown" }
local chatBuf = 0

vim.api.nvim_create_autocmd("FileType", {
	pattern = filetypes,
	callback = function (args)
		require("otter").activate()
		local bufnr = args.buf
		vim.api.nvim_create_autocmd("BufWritePost", {
			buffer = bufnr,
			callback = function ()
				require("otter").activate()
			end
		})
	end
})

vim.api.nvim_create_autocmd("user", {
	pattern = 'CodeCompanionRequestStarted',
	callback = function(request)
		chatBuf = request.buf
	end
})

vim.api.nvim_create_autocmd("user", {
	pattern = 'CodeCompanionRequestFinished',
	callback = function(request)
		local currentBuf = vim.api.nvim_get_current_buf()

		vim.cmd("buffer " .. chatBuf)
		require("otter").activate()
		vim.cmd("buffer " .. currentBuf)
	end
})

return {
	"jmbuhr/otter.nvim",
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
	},
	opts = {},
}
