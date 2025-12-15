-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.cmd("hi clear StatusLine")
vim.cmd("hi link StatusLine lualine_c_normal")

vim.api.nvim_create_user_command('Font', function(opts)
	vim.g.font = opts.args
	vim.g.updateFont()
end, { nargs = 1 })

vim.cmd([[
	au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]])

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python", "yaml", "rust" },
	callback = function()
		SetIndent()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "d",
	callback = function()
		vim.opt_local.indentexpr = ""
		vim.opt_local.cindent = true
	end,
})

vim.api.nvim_create_autocmd("BufRead", {
	pattern = { "*" },
	callback = function(args)
		if vim.bo[args.buf].modifiable then
			vim.opt.fileformat = "unix"
		end
	end,
})

vim.api.nvim_create_autocmd('User', {
	pattern = 'CodeCompanionRequestStarted',
	callback = function()
		vim.notify("Message sent", vim.log.levels.INFO)
		vim.schedule(function()
			vim.cmd('stopinsert')
		end)
	end,
})

local term_group = vim.api.nvim_create_augroup('TermGroup', { clear = true })

-- Set a buffer-local keymap when a terminal is opened
vim.api.nvim_create_autocmd('TermOpen', {
	group = term_group,
	desc = "Map q to quit terminal window in normal mode",
	callback = function()
		vim.keymap.set('n', 'q', '<Cmd>q<CR>', { buffer = true, silent = true })
	end,
})

require("config.functionality")
