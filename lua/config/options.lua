-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_cmp = "blink"
-- vim.g.ai_assistant = "codecompanion"
vim.g.ai_assistant = "avante"
vim.g.ai_cmp = false

vim.g.autoformat = false
vim.g.autoformat_align = 1 -- Only align code
vim.g.autoformat_disable = { "tabs_to_spaces" }
vim.g.snacks_animate = false

vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4 -- Number of spaces a tab counts for while editing
vim.opt.autoindent = true

vim.o.cmdheight = 0
vim.opt.laststatus = 3

vim.opt.scrolloff = 10

vim.o.guifont = "CommitMono Nerd Font Mono:h10"

vim.g.neovide_position_animation_length = 0.1
vim.g.neovide_cursor_animation_length = 0.1
vim.g.neovide_scroll_animation_length = 0.3
vim.g.neovide_hide_mouse_when_typing = true

vim.hl = vim.highlight -- workaround for :Inspect
