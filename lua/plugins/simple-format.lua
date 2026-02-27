return {
	"TheLazyCat00/simple-format",
	lazy = false,
	opts = {},
	config = function (_, opts)
		local simpleFormat = require("simple-format")
		simpleFormat.setup(opts)

		local function format(formattingFunc)
			return function ()
				vim.schedule(function ()
					formattingFunc("(<.->) *(<|punctuation%.delimiter|=,>)", "%1%2")
					formattingFunc("(<|punctuation%.delimiter|=,>) *(<.->)", "%1 %2")

					formattingFunc("(<.-|punctuation%.bracket|.-={>) *(<.-|punctuation%.bracket|.-=}>)", "%1%2")
					formattingFunc("(<.-|punctuation%.bracket|.-={>) -(%S.*%S) -(<.-|punctuation%.bracket|.-=})","%1 %2 %3")

					formattingFunc("(<.*>) *(<.-|punctuation%.bracket|.-={>)", "%1 %2")

					formattingFunc("(<|punctuation%.bracket|=%(>) *(.-)","%1%2")
					formattingFunc("(.-) *(<|punctuation%.bracket|=%)>)","%1%2")
				end)
			end
		end

		vim.api.nvim_create_autocmd("InsertLeave", {
			callback = format(simpleFormat.replace),
		})

		vim.api.nvim_create_user_command("Reveal", simpleFormat.reveal, {})
		vim.api.nvim_create_user_command("Format", format(simpleFormat.replaceFile), {})
	end
}
