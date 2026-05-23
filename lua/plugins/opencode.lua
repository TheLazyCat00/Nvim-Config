
return {
	"nickjvandyke/opencode.nvim",
	lazy = false,
	dependencies = {
		"folke/snacks.nvim",
	},
	init = function()
		vim.o.autoread = true

		vim.api.nvim_create_autocmd("DirChanged", {
			callback = function()
				pcall(function()
					require("opencode").stop()
				end)
			end,
		})
	end,
	keys = {
		{
			"<leader>aa",
			function()
				require("opencode").ask("@this: ", { submit = true })
			end,
			desc = "Ask opencode",
			mode = { "n", "x" },
		},
		{
			"<leader>ag",
			function()
				require("opencode").toggle()
			end,
			desc = "Toggle opencode",
			mode = { "n", "t" },
		},
		{
			"<leader>an",
			function()
				require("opencode").command("session.new")
			end,
			desc = "New opencode session",
		},
		{
			"<leader>aq",
			function()
				require("opencode").stop()
			end,
			desc = "Close opencode",
		},
		{
			"<leader>as",
			function()
				require("opencode").select()
			end,
			desc = "Select opencode",
			mode = { "n", "x" },
		},
	},
}
