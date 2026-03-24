return {
	"TheLazyCat00/focus-nvim",
	lazy = false,
	enabled = false,
	opts = {
		languages = {
			["cs"] = [[
				(method_declaration) @func
				(constructor_declaration) @func
				(operator_declaration) @func
			]],
			["lua"] = "(function_declaration) @func",
		},
	},
	config = function (_, opts)
		local focusNvim = require("focus-nvim")
		focusNvim.setup(opts)
		vim.api.nvim_create_user_command(
			"ResetFolds",
			function() vim.schedule(focusNvim.reset) end,
			{}
		)
	end,
	keys = {
		{
			"l",
			function () require("focus-nvim").open("l") end,
			desc = "Right"
		}
	}
}
