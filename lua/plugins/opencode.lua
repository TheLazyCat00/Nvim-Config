
return {
	"nickjvandyke/opencode.nvim",
	lazy = false,
	dependencies = {
		"folke/snacks.nvim",
	},
	init = function()
		vim.g.opencode_opts = {
			server = {
				toggle = function()
					require("opencode.terminal").toggle("opencode --port", {
						split = "right",
						width = math.floor(vim.o.columns * 0.35),
					})
				end,
			},
		}

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
		{
			"<C-.>",
			function()
				require("opencode").toggle()
			end,
			desc = "Toggle opencode",
			mode = { "n", "t" },
		},
	},
}
