return { 
	{ "<C-j>", function ()
		vim.api.nvim_input("<C-n>")
	end, desc = "Next" },
	{ "<C-k>", function ()
		vim.api.nvim_input("<C-p>")
	end, desc = "Prev" },
}
