-- return {
-- 	"github/copilot.vim",
-- 	event = "VeryLazy",
-- 	config = function()
-- 		vim.g.copilot_no_tab_map = true
-- 	end,
-- 	keys = {
-- 		{ "<C-CR>", 'copilot#Accept("")', mode = "i", silent = true, expr = true, replace_keycodes = false }
-- 	}
-- }

return {
	"zbirenbaum/copilot.lua",
	dependencies = {
		"copilotlsp-nvim/copilot-lsp",
	},
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = true,
			debounce = 15,
			trigger_on_accept = true,
			keymap = {
				accept = "<C-CR>",
				accept_word = false,
				accept_line = false,
				next = false,
				prev = false,
				dismiss = false,
				toggle_auto_trigger = false,
			},
		},
		nes = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept_and_goto = "<S-CR>",
				accept = false,
				dismiss = false,
			},
		},
	}
}
