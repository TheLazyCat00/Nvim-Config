-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")

wk.add({
	-- Insert mode mappings
	{
		mode = "i",
		{ "<C-k>", "<Up>", desc = "Move cursor up" },
		{ "<C-h>", "<Left>", desc = "Move cursor left" },
		{ "<C-j>", "<Down>", desc = "Move cursor down" },
		{ "<C-l>", "<Right>", desc = "Move cursor right" },
	},

	-- Terminal mode mappings
	{
		mode = "t",
		{ "<Esc>", "<C-\\><C-n>", desc = "Exit terminal mode" },
	},

	-- Visual mode mappings
	{
		mode = "x",
		{ ".", ":norm .<CR>", desc = "Repeat last change" },
		{ "@", ":norm @q<CR>", desc = "Execute macro 'q'" },
	},

	-- Normal and Visual mode mappings
	{
		mode = { "n", "v" },
		{ "-", '"_', desc = "Use black hole register" },
	},

	-- Normal mode mappings
	{
		mode = "n",
		{ "<C-r>", "<NOP>", desc = "Disable redo (use U instead)" },
		{ "U", ":redo<CR>", desc = "Redo" },
		{ "s", "<NOP>", desc = "Disable substitute (used as prefix)" },
		{ "sj", ":wa<CR>", desc = "Save all buffers" },
		{ "sk", ":wqa<CR>", desc = "Save all and quit" },
		{
			">",
			function()
				vim.api.nvim_command("normal! >>")
			end,
			desc = "Indent line right"
		},
		{
			"<",
			function()
				vim.api.nvim_command("normal! <<")
			end,
			desc = "Indent line left"
		},
	},
})

-- Auto format on paste (optional)
local autoformatEnabled = false

if autoformatEnabled then
	wk.add({
		{
			mode = "n",
			{
				"p",
				function()
					local row, col = unpack(vim.api.nvim_win_get_cursor(0))
					vim.api.nvim_command('normal! p')
					vim.api.nvim_command('normal! =ag')
					vim.defer_fn(function()
						vim.api.nvim_win_set_cursor(0, { row, col })
					end, 1)
				end,
				desc = "Paste and auto-format"
			}
		}
	})
end
