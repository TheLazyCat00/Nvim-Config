-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.bo.expandtab = false -- Use tabs instead of spaces
		vim.bo.tabstop = 4 -- Number of spaces per tab
		vim.bo.shiftwidth = 4 -- Number of spaces for indentation
		vim.bo.softtabstop = 4 -- Tab key behaves as 4 spaces
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