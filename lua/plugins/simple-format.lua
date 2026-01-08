return {
	"TheLazyCat00/simple-format",
	event = "BufReadPost",
	opts = {},
	config = function (_, opts)
		local simpleFormat = require("simple-format")
		simpleFormat.setup(opts)
		local replace = simpleFormat.replace

		local function format()
			vim.schedule(function ()
				-- replace("(<.->) *(<|operator|=[%+%-%*/%=]*>)", "%1 %2")
				-- replace("(<|operator|=[%+%-%*/%=]*>) *(<.->)", "%1 %2")

				replace("(<.->) *(<|punctuation%.delimiter|=,>)", "%1%2")
				replace("(<|punctuation%.delimiter|=,>) *(<.->)", "%1 %2")

				replace("(<.-|punctuation%.bracket|.-={>) *(<.-|punctuation%.bracket|.-=}>)", "%1%2")
				replace("(<.-|punctuation%.bracket|.-={>) -(%S.*%S) -(<.-|punctuation%.bracket|.-=})","%1 %2 %3")

				replace("(<.*>) *(<.-|punctuation%.bracket|.-={>)", "%1 %2")

				replace("(<|punctuation%.bracket|=%(>) *(.-)","%1%2")
				replace("(.-) *(<|punctuation%.bracket|=%)>)","%1%2")
			end)
		end

		vim.api.nvim_create_autocmd("InsertLeave", {
			callback = format,
		})

		vim.api.nvim_create_user_command("Reveal", simpleFormat.reveal, {})
	end
}
