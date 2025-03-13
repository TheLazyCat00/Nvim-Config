-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Define the uppercase operator function

function _G.lineOperator()
	local view = vim.fn.winsaveview()

	vim.cmd('normal! ^v$')

	vim.schedule(function()
		vim.fn.winrestview(view)
	end)
end

function _G.replaceWithClipboard(motion_type)
	local start_pos = vim.fn.getpos("'[")
	local end_pos = vim.fn.getpos("']")

	-- Get clipboard content (using the + register for system clipboard)
	local clipboard_text = vim.fn.getreg('+')
	clipboard_text = vim.trim(clipboard_text)

	-- Split clipboard text into lines
	local clipboard_lines = vim.split(clipboard_text, '\n', { plain = true })

	-- Replace the text
	vim.api.nvim_buf_set_text(
		0,                    -- buffer number (0 = current)
		start_pos[2] - 1,    -- start line
		start_pos[3] - 1,    -- start col
		end_pos[2] - 1,      -- end line
		end_pos[3],          -- end col
		clipboard_lines      -- replacement text from clipboard
	)
end

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
		mode = { "n", "x" },
		{ "-", '"_', desc = "Use black hole register" },
	},

	-- Normal mode mappings
	{
		mode = "n",
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
		{
			"r",
			function()
				vim.o.operatorfunc = 'v:lua.replaceWithClipboard'
				return 'g@'
			end,
			desc = "Replace with Clipboard",
			expr = true
		},
	},
	{
		mode = {"o", "x"},
		{
			"o",
			_G.lineOperator,
			desc = "Current line",
		}
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
