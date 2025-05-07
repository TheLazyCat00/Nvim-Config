-- INFO: place to put more complex logic

local wk = require("which-key")

local function lineMotion()
	function _G.lineMotion()
		local lastOperator = vim.v.operator

		if lastOperator == "d" then
			local lineContent = vim.fn.getline(".")
			if lineContent:match("%S") == nil then
				vim.api.nvim_feedkeys('"_dd', "n", true)
			else
				vim.api.nvim_feedkeys('dd', "n", true)
			end
		elseif lastOperator == "c" then
			vim.cmd('normal! ^v$h')
		else
			vim.api.nvim_feedkeys(lastOperator .. lastOperator, "n", true)
		end
	end

	wk.add({
		{
			mode = "x",
			{ "u", "V", desc = "Currentline" },
		},
		{
			mode = "o"  ,
			{
				"u",
				_G.lineMotion,
				desc = "Current line",
			},
		},
	})


	local doubles = { "d", "y", "c", "=", "<", ">", "v" }
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
end

lineMotion()

local function getCurrentNode()
	local current = vim.treesitter.get_node({ ignore_injections = false })
	if not current then return end -- Handle case where no node is found
	local start_row, start_col, end_row, end_col = current:range()

	vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
	vim.cmd("normal! v")
	end_row = end_row + 1
	if end_row > vim.api.nvim_buf_line_count(0) then
		end_row = vim.api.nvim_buf_line_count(0)
		local last = vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, true)[1]
		end_col = #last
	end
	vim.api.nvim_win_set_cursor(0, { end_row, end_col - 1 })
end

local function getCurrentNodeVisual()
	local current = vim.treesitter.get_node({ ignore_injections = false })
	if not current then return end -- Handle case where no node is found
	local start_row, start_col, end_row, end_col = current:range()

	vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
	vim.cmd("normal! o")
	end_row = end_row + 1
	if end_row > vim.api.nvim_buf_line_count(0) then
		end_row = vim.api.nvim_buf_line_count(0)
		local last = vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, true)[1]
		end_col = #last
	end
	vim.api.nvim_win_set_cursor(0, { end_row, end_col - 1 })
end

local isActive = false

vim.api.nvim_create_autocmd('ModeChanged', {
	-- group = groupId,
	pattern = '*', -- Apply to all buffers
	callback = function (args)
		if not isActive then
			return
		end

		if vim.api.nvim_get_mode().mode ~= "no" then
			return
		end

		vim.schedule(function ()
			if vim.api.nvim_get_mode().mode ~= "no" then
				return
			end
			vim.api.nvim_input("m")
		end)
	end,
})

wk.add({
	{ "m", getCurrentNode, desc = "Node under cursor", mode = "o" },
	{ "m", getCurrentNodeVisual, desc = "Node under cursor", mode = "x" },
	{
		"<leader>m",
		function ()
			isActive = not isActive
		end,
		desc = "Toggle autonode",
		mode = "n",
	}
})
-- Seed the random number generator
math.randomseed(os.time())

-- Helper function to generate a random hex color string
local function generate_random_hex_color()
  local r = math.random(0, 255)
  local g = math.random(0, 255)
  local b = math.random(0, 255)
  return string.format("#%02X%02X%02X", r, g, b)
end

-- Function to set WinBar and WinBarNC to random colors
local function set_random_winbar_colors()
  local active_fg = generate_random_hex_color()
  local active_bg = generate_random_hex_color()
  local inactive_fg = generate_random_hex_color()
  local inactive_bg = generate_random_hex_color()

  vim.api.nvim_set_hl(0, 'WinBar', { fg = active_fg, bg = active_bg, force = true })
  vim.api.nvim_set_hl(0, 'WinBarNC', { fg = inactive_fg, bg = inactive_bg, force = true })
  
  -- Optional: print a confirmation
  -- print("WinBar colors randomized!")
end

-- Create a user command to trigger the randomization
vim.api.nvim_create_user_command('RandomizeWinbar', set_random_winbar_colors, {
  desc = 'Set WinBar and WinBarNC to random colors'
})

-- To make this visible, you need to have the winbar option set.
-- For example, in your Neovim config:
-- vim.opt.winbar = "%#WinBar# Window: %w %#WinBarNC# Buffer: %b (%f)"
-- Or a simpler one:
-- vim.opt.winbar = "%#WinBar#%f%m%r%h%w"
--
-- After loading this code, you can run :RandomizeWinbar
