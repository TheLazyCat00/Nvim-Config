return {
	{ "<leader>qq", "<NOP>", hidden = true } ,
	{ "<leader>q", "<NOP>", hidden = true } ,
	{ "]M", "<NOP>", hidden = true } ,
	{ "[M", "<NOP>", hidden = true } ,

	{ "U", "<cmd>redo<CR>", desc = "Redo" },
	{ "sj", "<cmd>wa<CR>", desc = "Save all buffers" },
	{ "sk", "<cmd>wqa<CR>", desc = "Save all and quit" },
	{ ">", "<cmd>norm! >><CR>", desc = "Indent line right" },
	{ "<", "<cmd>norm! <<<CR>", desc = "Indent line left" },

	{ "<leader>p", group = "profiler" } ,
	{ "s", "<NOP>", group = "session/exit" } ,
}
