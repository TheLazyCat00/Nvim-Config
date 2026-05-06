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
	end,
	init = function ()
		vim.api.nvim_create_autocmd("User", {
			pattern = "CodeDiffOpen",
			callback = function ()
				vim.defer_fn(require("focus-nvim").disable, 100)
			end
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "CodeDiffClose",
			callback = function ()
				vim.defer_fn(require("focus-nvim").enable, 100)
			end
		})
	end,
	keys = {
		{
			"l",
			function () require("focus-nvim").open("l") end,
			desc = "Right"
		}
	}
}
