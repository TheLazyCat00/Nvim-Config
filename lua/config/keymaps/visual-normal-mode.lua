return {
	{ "-", '"_', desc = "Use black hole register" },
	{ "0", "<cmd>norm! ^<CR>" },
	{ "^", "<cmd>norm! 0<CR>" },
	{ "<C-u>", "<cmd>norm! <C-u>zz<CR>" },
	{ "<C-d>", "<cmd>norm! <C-d>zz<CR>" },
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
