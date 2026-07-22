return {
	"shortcuts/no-neck-pain.nvim",
	dependencies = { "stevearc/aerial.nvim" },
	enabled = true,
	lazy = false,
	version = "*",
	opts = {
		autocmds = {
			enableOnVimEnter = true,
		},
		callbacks = {
			postEnable = function()
				vim.schedule(function()
					require("aerial").open({ focus = false, direction = "left" })
				end)
			end,
			preDisable = function()
				require("aerial").close_all()
			end,
		},
		integrations = {
			aerial = {
				position = "left",
				reopen = true,
			},
			dashboard = {
				enabled = true,
			},
		},
	}
}
