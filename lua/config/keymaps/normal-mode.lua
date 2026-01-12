return {
	{ "<leader>qq", "<NOP>", hidden = true } ,
	{ "<leader>q", "<NOP>", hidden = true } ,
	{ "]M", "<NOP>", hidden = true } ,
	{ "[M", "<NOP>", hidden = true } ,
	{ "<leader>ft", "<NOP>", hidden = true } ,
	{ "<leader>fT", "<NOP>", hidden = true } ,

	{ "U", "<Cmd>redo<CR>", desc = "Redo" },
	{ "sj", "<Cmd>wa<CR>", desc = "Save all buffers" },
	{ "sk", "<Cmd>wa | qa!<CR>", desc = "Save all and quit" },
	{ ">", "<Cmd>norm! >><CR>", desc = "Indent line right" },
	{ "<", "<Cmd>norm! <<<CR>", desc = "Indent line left" },

	{ "<leader>p", group = "profiler" } ,
	{ "s", "<NOP>", group = "session/exit" } ,
}
