return {
	'akinsho/toggleterm.nvim',
	version = "*",
	opts = {
		on_create = function ()
			vim.cmd([[TermExec cmd="pwsh"]])
			vim.cmd([[TermExec cmd="clear"]])
			vim.cmd([[TermExec cmd="pwsh"]])
			vim.cmd([[ToggleTerm]])
			vim.cmd([[ToggleTerm]])
		end,
		on_open = function ()
			vim.schedule(function ()
				vim.cmd.startinsert()
			end)
		end,
		autochdir = true,
	},
	keys = {
		{ "<leader>t", function ()
			vim.cmd("ToggleTerm size=80 direction=vertical name=main")
		end }
	}
}
