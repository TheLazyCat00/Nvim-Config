vim.g.updateFont = function ()
	vim.o.guifont = vim.g.font .. ":h" .. vim.g.size
end

vim.g.neovide_refresh_rate = 60
vim.g.neovide_position_animation_length = 0.1
vim.g.neovide_cursor_short_animation_length = 0.1
vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_cursor_animation_length = 0.1
vim.g.neovide_cursor_trail_size = 0.6
vim.g.neovide_hide_mouse_when_typing = false

vim.g.font = "CommitMono Nerd Font Mono"
vim.g.size = "10"

vim.g.updateFont()

vim.api.nvim_create_user_command('Size', function(opts)
	vim.g.size = opts.args
	vim.g.updateFont()
end, { nargs = 1 })
