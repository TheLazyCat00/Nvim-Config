-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function line_sub(line_num, pattern, replacement)
	-- Save the current window view
	local view = vim.fn.winsaveview()

	-- Disable screen redraws
	vim.opt.lazyredraw = true

	-- Do the substitution silently on just that line
	vim.cmd(string.format('keepjumps silent! %d s/%s/%s/ge',
		line_num,   -- Target line number
		pattern,    -- Search pattern
		replacement -- Replacement text
	))

	-- Restore the saved view
	vim.fn.winrestview(view)

	-- Re-enable screen redraws
	vim.opt.lazyredraw = false
end

function _G.formatCurrentLine()
	local word = [[\(\w\)]]
	local search = [[\(=\|{\|}\)]]

	local pattern1 = word .. search
	local pattern2 = search .. word

	local replace_group = [[\1 \2]]

	line_sub(vim.fn.line("."), pattern1, replace_group)
	line_sub(vim.fn.line("."), pattern2, replace_group)
end

vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*:n", -- Triggers when changing TO normal mode
	callback = _G.formatCurrentLine
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.bo.expandtab = false -- Use tabs instead of spaces
		vim.bo.tabstop = 4       -- Number of spaces per tab
		vim.bo.shiftwidth = 4    -- Number of spaces for indentation
		vim.bo.softtabstop = 4   -- Tab key behaves as 4 spaces
	end,
})

vim.api.nvim_create_user_command('W', 'w', { nargs = 0 })
vim.api.nvim_create_user_command('Wqa', 'wqa', { nargs = 0 })
vim.api.nvim_create_user_command('Q', 'q', { nargs = 0 })
vim.api.nvim_create_user_command('Qa', 'qa', { nargs = 0 })


vim.cmd("language en_US.UTF-8")
vim.cmd([[
	au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]])

vim.opt.scroll = 15
