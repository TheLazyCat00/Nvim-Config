return {
	"TheLazyCat00/simple-format",
	event = "BufReadPost",
	-- enabled = false,
	opts = {},
	config = function (_, opts)
		local simple_format = require("simple-format")
		simple_format.setup(opts)
		local replace = simple_format.replace
		vim.api.nvim_create_autocmd("InsertLeave", {
			callback = function()
				vim.schedule(function ()
					replace("(%S)(<operator=.->)", "%1 %2")
					replace("(<operator=.->)(%S)", "%1 %2")
					replace("(<punctuation.delimiter=,>)(%S)", "%1 %2")
					replace("(<punctuation.bracket={>)(%S)", "%1 %2")
					replace("(%S)(<punctuation.bracket=}>)", "%1 %2")
					replace("(<punctuation.bracket=.->) (<punctuation.bracket=.->)", "%1%2")
				end)
			end,
		})
	end
}
