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


---@return snacks.picker.Config
local function recent_dirs()
	return {
		items = {
			{
				file = "C:/JUCE",
				dir = true
			},
		},
		actions = {
			confirm = function(picker, item)
				picker:close()
				if not item then
					return
				end
			end
		},
		format = Snacks.picker.format.filename,
		preview = Snacks.picker.preview.directory, -- Use the item.preview data
		-- Optional: auto_confirm = true,
		title = "My Custom Picker"
	}
end

-- vim.fn.chdir([[C:\Users\TheLa\Documents\CODE\Projects\CaveGame]])
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function ()
		local filepath = vim.fn.stdpath("data") .. "/recent-dirs"
		local lines = vim.fn.readfile(filepath)

		local cwd = vim.fn.getcwd():gsub("\\", "/")
		local cur_buf_path = vim.api.nvim_buf_get_name(0):gsub("\\", "/")
		local line_data = cwd .. "" .. cur_buf_path
		for i, value in ipairs(lines) do
			if value:match("(.-)") == cwd then
				table.remove(lines, i)
				break
			end
		end

		table.insert(lines, 1, line_data)
		vim.fn.writefile(lines, filepath)
	end
})
