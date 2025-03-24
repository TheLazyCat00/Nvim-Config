-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

function _G.line_motion()
	local view = vim.fn.winsaveview()
	vim.opt.lazyredraw = true

	local last_operator = vim.v.operator

	if last_operator == "d" then
		vim.api.nvim_feedkeys("dd", "n", true)
	elseif last_operator == "y" then
		vim.api.nvim_feedkeys("yy", "n", true)
	else
		vim.cmd('normal! ^v$h')
	end

	if last_operator ~= "c" then
		vim.schedule(function()
			vim.fn.winrestview(view)
		end)
	end

	vim.opt.lazyredraw = false
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
		{ ".", "<cmd>norm .<CR>", desc = "Repeat last change" },
		{ "@", "<cmd>norm @q<CR>", desc = "Execute macro 'q'" },
	},

	-- Normal and Visual mode mappings
	{
		mode = { "n", "x" },
		{ "-", '"_', desc = "Use black hole register" },
	},

	-- Normal mode mapping
	{
		mode="n",
		{ "U", "<cmd>redo<CR>", desc = "Redo" },
		{ "<leader>qq", "<NOP>", hidden = true } ,
		{ "sj", "<cmd>wa<CR>", desc = "Save all buffers" },
		{ "sk", "<cmd>wqa<CR>", desc = "Save all and quit" },
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
	{
		mode = {"o", "x" } ,
		{
			"u",
			_G.line_motion,
			desc = "Current line",
		},
	},
})

wk.add({
	{
		mode = "n",
		{ "<leader>a", group = "ai assistant", mode = { "x", "n" }},
		{ "<leader>p", group = "profiler" } ,
		{ "s", "<NOP>", group = "session/exit" } ,
	}
})

local doubles = { "d", "y", "c", "=", "<", ">", "z" }

local disabledDoubles = {
	mode = "o"
}

for index, double in ipairs(doubles) do
	disabledDoubles[index] = {
		double,
		"<NOP>"
	}
end

wk.add(disabledDoubles)

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
