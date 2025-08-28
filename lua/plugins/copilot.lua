return {
	"github/copilot.vim",
	event = "VeryLazy",
	config = function()
		vim.api.nvim_set_keymap("i", "<C-CR>", 'copilot#Accept("")', { silent = true, expr = true })
		vim.g.copilot_no_tab_map = true
	end,
}
