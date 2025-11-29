return {
	"TheLazyCat00/simple-format",
	event = "BufReadPost",
	opts = {},
	config = function (_, opts)
		local simpleFormat = require("simple-format")
		simpleFormat.setup(opts)
		local replace = simpleFormat.replace
		vim.api.nvim_create_autocmd("InsertLeave", {
			callback = function()
				vim.schedule(function ()
					-- simpleFormat.reveal()
					replace("(%S) -(<.-|operator|.-=.->)", "%1 %2")
					replace("(<.-|operator|.-=.->) -(%S)", "%1 %2")
					replace("(<.-|punctuation.delimiter|.-=,>) -(%S)", "%1 %2")
					replace("(<.-|punctuation.bracket|.-={>) -(<.-|punctuation.bracket|.-=}>)", "%1%2")
					replace("(<.-|punctuation.bracket|.-={>) -(%S.-%S) -(<.-|punctuation.bracket|.-=}>)", "%1 %2 %3")
					replace("(<.-|punctuation.bracket|.-=%(>) -(%S.-%S) -(<.-|punctuation.bracket|.-=%)>)", "%1%2%3")
					replace("(<.-|punctuation.bracket|.-=%(>) -(<.-|punctuation.bracket|.-=%)>)", "%1%2")
				end)
			end,
		})
	end
}
