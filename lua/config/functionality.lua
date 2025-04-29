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
	vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col })
end

local function getCurrentNodeVisual()
	local current = vim.treesitter.get_node({ ignore_injections = false })
	if not current then return end -- Handle case where no node is found
	local start_row, start_col, end_row, end_col = current:range()

	vim.cmd("normal! " .. vim.fn.mode(0))
	vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
	vim.cmd("normal! v")
	vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col })
end

wk.add({
	{ "m", getCurrentNode, desc = "Node under cursor", mode = "o" },
	{ "m", getCurrentNodeVisual, desc = "Node under cursor", mode = "x" },
})
