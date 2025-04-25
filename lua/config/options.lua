-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.loader.enable()

vim.cmd("language en_US.UTF-8")
vim.g.maplocalleader = " "

vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4 -- Number of spaces a tab counts for while editing
vim.opt.autoindent = true

vim.o.cmdheight = 0
vim.opt.laststatus = 3
vim.opt.scrolloff = 10

vim.g.lazyvim_picker = "snacks"
vim.g.lazyvim_cmp = "blink"
vim.g.ai_assistant = "codecompanion"
vim.g.ai_cmp = false
vim.g.static_scrolling = false

vim.g.autoformat = false
vim.g.autoformat_align = 1 -- Only align code
vim.g.snacks_animate = false

vim.hl = vim.highlight -- workaround for :Inspect

require("config.neovide")
