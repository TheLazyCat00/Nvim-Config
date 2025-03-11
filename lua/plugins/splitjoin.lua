return {
	'Wansmer/treesj',
	event = "BufRead",
	dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
	config = function()
		vim.keymap.set('n', 'm', require('treesj').toggle)
	end
}
