-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.loader.enable()

vim.cmd("language en_US.UTF-8")
vim.g.maplocalleader = " "

vim.opt.undolevels = 1000
vim.opt.undofile = true
vim.opt.autoindent = true

local shell = "wsl"
local shellConfigs = {
	pwsh = function ()
		vim.o.shell = "pwsh"
		vim.o.shellcmdflag = "-Command"
		vim.o.shellquote = ""
		vim.o.shellxquote = ""
	end,
	msys2 = function()
		vim.o.shell = "C:/msys64/msys2_shell.cmd -defterm -here -no-start -ucrt64"
		vim.o.shellcmdflag = "-c"
		vim.o.shellquote = ""
		vim.o.shellxquote = ""
	end,
	wsl = function ()
		vim.o.shell = "bash"
		vim.o.shellcmdflag = "-c"
		vim.o.shellquote = ""
		vim.o.shellxquote = ""
	end
}
shellConfigs[shell]()

vim.o.cmdheight = 0
vim.opt.laststatus = 3
vim.opt.scrolloff = 10

vim.g.lazyvim_picker = "snacks"
vim.g.lazyvim_cmp = "blink"
vim.g.ai_cmp = false

vim.g.autoformat = false
vim.g.autoformat_align = 1 -- Only align code
vim.g.snacks_animate = false

vim.hl = vim.highlight -- workaround for :Inspect

--- method keymaps are useless
vim.keymap.set("n", "]m", "<NOP>")
vim.keymap.set("n", "[m", "<NOP>")

vim.filetype.add({
	extension = {
		ixx = "cpp",
	},
})

function Print(value)
	vim.notify(vim.inspect(value))
end

function SetIndent()
	vim.opt.expandtab = false
	vim.opt.tabstop = 4
	vim.opt.shiftwidth = 4
	vim.opt.softtabstop = 4 -- Number of spaces a tab counts for while editing
end

SetIndent()

vim.g.updateFont = function ()
	vim.opt.guifont = vim.g.font .. ":h" .. vim.g.size
end

vim.g.font = "CommitMono Nerd Font Mono"
vim.g.size = "10"

vim.g.updateFont()

if vim.g.neovide then
	require("config.neovide")
end
