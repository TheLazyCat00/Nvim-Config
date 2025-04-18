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
