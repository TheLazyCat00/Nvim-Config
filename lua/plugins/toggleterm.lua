return {
	'akinsho/toggleterm.nvim',
	version = "*",
	opts = {
		on_create = function ()
			vim.cmd([[TermExec cmd="powershell"]])
		end
	},
	keys = {
		{ "<leader>t", "<Cmd>ToggleTerm size=80 direction=vertical name=main<CR>" }
	}
}
