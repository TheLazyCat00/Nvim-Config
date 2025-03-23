return {
	"TheLazyCat00/simple-format",
	event = "BufReadPost",
	config = function ()
		vim.api.nvim_create_autocmd("InsertLeave", {
			callback = function()
				vim.schedule(function ()
					local replace = require("simple-format").replace
					replace("(%S)(<operator>)", "%1 %2")
					replace("(<operator>)(%S)", "%1 %2")
					replace("(%S)(<constructor>)", "%1 %2")
					replace("(<constructor>)(%S)", "%1 %2")
					replace("(<constructor>) (<punctuation.bracket>)", "%1%2")
					replace("(<punctuation.bracket>) (<constructor>)", "%1%2")
					replace("(<constructor>) (<punctuation.delimiter>)", "%1%2")
				end)
			end,
		})
	end
}
