return {
	"folke/sidekick.nvim",
	-- enabled = false,
	opts = {
		cli = {
			win = {
				keys = {
					buffers       = { "<c-b>", "buffers"   , mode = "nt", desc = "open buffer picker" },
					files         = { "<c-f>", "files"     , mode = "nt", desc = "open file picker" },
					hide_n        = { "q"    , "hide"      , mode = "n" , desc = "hide the terminal window" },
					hide_ctrl_q   = { "<c-q>", "hide"      , mode = "n" , desc = "hide the terminal window" },
					hide_ctrl_dot = { "<c-.>", "hide"      , mode = "nt", desc = "hide the terminal window" },
					hide_ctrl_z   = { "<c-z>", "blur"      , mode = "nt", desc = "go back to the previous window without hiding the terminal" },
					prompt        = { "<c-p>", "prompt"    , mode = "t" , desc = "insert prompt or context" },
					stopinsert    = { "<c-q>", "stopinsert", mode = "t" , desc = "enter normal mode" },
					-- Navigate windows in terminal mode. Only active when:
					-- * layout is not "float"
					-- * there is another window in the direction
					-- With the default layout of "right", only `<c-h>` will be mapped
					scroll_up     = { "<c-u>", "<PageUp>", mode = "t", desc = "scroll page up" },
					scroll_down   = { "<c-d>", "<PageDown>", mode = "t", desc = "scroll page down" },
				},
			}
		}
	},
	keys = {
		-- nes is also useful in normal mode
		{ "<tab>", LazyVim.cmp.map({ "ai_nes" }, "<tab>"), mode = { "n" }, expr = true },
		{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
		{
			"<c-.>",
			function() require("sidekick.cli").focus() end,
			desc = "Sidekick Focus",
			mode = { "n", "t", "i", "x" },
		},
		{
			"<leader>aa",
			function() require("sidekick.cli").toggle({ name = "opencode" }) end,
			desc = "Sidekick Toggle CLI",
		},
		{
			"<leader>as",
			function() require("sidekick.cli").select() end,
			-- Or to select only installed tools:
			-- require("sidekick.cli").select({ filter = { installed = true } })
			desc = "Select CLI",
		},
		{
			"<leader>ad",
			function() require("sidekick.cli").close() end,
			desc = "Detach a CLI Session",
		},
		{
			"<leader>at",
			function() require("sidekick.cli").send({ msg = "{this}" }) end,
			mode = { "x", "n" },
			desc = "Send This",
		},
		{
			"<leader>af",
			function() require("sidekick.cli").send({ msg = "{file}" }) end,
			desc = "Send File",
		},
		{
			"<leader>av",
			function() require("sidekick.cli").send({ msg = "{selection}" }) end,
			mode = { "x" },
			desc = "Send Visual Selection",
		},
		{
			"<leader>ap",
			function() require("sidekick.cli").prompt({ name = "opencode" }) end,
			mode = { "n", "x" },
			desc = "Sidekick Select Prompt",
		},
	},
}
