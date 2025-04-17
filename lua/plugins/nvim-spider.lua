return {
	"chrisgrieser/nvim-spider",
	enabled = false,
	opts = {
		skipInsignificantPunctuation = true,
		consistentOperatorPending = false, -- see "Consistent Operator-pending Mode" in the README
		subwordMovement = false,
		customPatterns = {}, -- check "Custom Movement Patterns" in the README for details
	},
	keys = {
		{ "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
		{ "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
		{ "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
	},
}
