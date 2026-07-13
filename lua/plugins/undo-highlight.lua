local normalModeOnly = function(ctx)
	-- Don't highlight during macro playback
	if vim.fn.reg_executing() ~= "" then
		return false
	end
	-- Only highlight if we're in Normal mode
	if not vim.api.nvim_get_mode().mode:find("n") then
		return false
	end
	return true
end

return {
	'aileot/emission.nvim',
	lazy = false,
	opts = {
		highlight = {
			duration = 300,
		},
		attach = {
			-- Useful to avoid extra attaching attempts in simultaneous buffer editing
			-- such as `:bufdo` or `:cdo`.
			delay = 10,
			excluded_buftypes = {
				"help",
				"nofile",
				"terminal",
				"prompt",
			},
			-- NOTE: Nothing is excluded by default. Add any as you need, but check
			-- the 'buftype' at first.
			excluded_filetypes = {
				-- "oil",
			},
		},
		added = {
			enabled = true,
			filter = normalModeOnly,
		},
		removed = {
			enabled = true,
			filter = normalModeOnly,
		},
	},
	config = function (_, opts)
		vim.api.nvim_create_autocmd("User", {
			pattern="SnacksDashboardClosed",
			callback = function()
				vim.defer_fn(function ()
					require("emission").setup(opts)
				end, 10)
			end,
		})
	end
}
