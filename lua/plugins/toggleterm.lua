return {
	'akinsho/toggleterm.nvim',
	version = "*",
	opts = {
		on_create = function ()
			vim.cmd([[TermExec cmd="pwsh"]])
		end
	},
	keys = {
		{ "<leader>t", "<Cmd>ToggleTerm size=80 direction=vertical name=main<CR>" }
	}
}
