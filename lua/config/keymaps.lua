-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")

wk.add({
	{
		mode = "i",
		require("config.keymaps.insert-mode")
	},
	{
		mode = "n",
		require("config.keymaps.normal-mode")
	},
	{
		mode = "x",
		require("config.keymaps.visual-mode")
	},
	{
		mode = "o",
		require("config.keymaps.o-pending")
	},
	{
		mode = { "n", "x" },
		require("config.keymaps.visual-normal-mode")
	},
	{
		mode = "t",
		require("config.keymaps.terminal")
	},
})
