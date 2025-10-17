return {
	{ "-", '"_', desc = "Use black hole register" },
	{ "0", "<Cmd>norm! ^<CR>", },
	{ "^", "<Cmd>norm! 0<CR>" },
	{ "<C-u>", "<Cmd>norm! <C-u>zz<CR>" },
	{ "<C-d>", "<Cmd>norm! <C-d>zz<CR>" },
	{
		"x",
		function ()
			local lineContent = vim.fn.getline(".")
			if lineContent == "" then
				vim.cmd('normal! "_dd')
			else
				vim.cmd('normal! "_x')
			end
		end,
	},
	{
		"X",
		function ()
			local lineContent = vim.fn.getline(".")
			if lineContent == "" then
				vim.cmd('normal! "_dd')
			else
				vim.cmd('normal! "_X')
			end
		end,
	},
	{ "<leader>a", group = "ai assistant", mode = { "x", "n" }},
}
