-- codediff forces 'wrap' off on its diff panes every time it renders, so turn
-- it back on whenever that happens.
local function wrap_panes()
	local ok, lifecycle = pcall(require, "codediff.ui.lifecycle")
	if not ok then return end
	for _, win in ipairs({ lifecycle.get_windows(vim.api.nvim_get_current_tabpage()) }) do
		if win and vim.api.nvim_win_is_valid(win) and not vim.wo[win].wrap then
			vim.wo[win].wrap = true
		end
	end
end

return {
	"esmuellert/codediff.nvim",
	cmd = "CodeDiff",
	init = function ()
		vim.api.nvim_create_autocmd("User", {
			pattern = { "CodeDiffOpen", "CodeDiffFileSelect" },
			callback = function () vim.schedule(wrap_panes) end,
		})

		vim.api.nvim_create_autocmd("OptionSet", {
			pattern = "wrap",
			nested = true,
			callback = function () vim.schedule(wrap_panes) end,
		})
	end,
	opts = {
		keymaps = {
			view = {
				next_hunk = "]h",
				prev_hunk = "[h",
			}
		}
	},
}
