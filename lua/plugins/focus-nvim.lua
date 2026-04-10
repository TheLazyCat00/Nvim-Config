return {
	"TheLazyCat00/focus-nvim",
	lazy = false,
	opts = {
		languages = {
			["cs"] = [[
				(method_declaration) @fold
				(constructor_declaration) @fold
				(operator_declaration) @fold
			]],
			["lua"] = "(function_declaration) @fold",
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
