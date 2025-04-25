return {
	'romgrk/barbar.nvim',
	event = "UIEnter",
	dependencies = {
		'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
		'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
	},
	opts = {
		clickable = false,

		exclude_ft = {},
		exclude_name = {'package.json'},

		-- A buffer to this direction will be focused (if it exists) when closing the current buffer.
		-- Valid options are 'left' (the default), 'previous', and 'right'
		focus_on_close = 'left',

		-- If true, new buffers will be inserted at the start/end of the list.
		-- Default is to insert after current buffer.
		insert_at_end = true,
		insert_at_start = false,

		-- Sets the maximum padding width with which to surround each tab
		maximum_padding = 100,

		-- Sets the minimum padding width with which to surround each tab
		minimum_padding = 1,

		-- Set the filetypes which barbar will offset itself for
		sidebar_filetypes = {
			-- Use the default values: {event = 'BufWinLeave', text = '', align = 'left'}
			NvimTree = true,
			-- Or, specify the text used for the offset:
			undotree = {
				text = 'undotree',
				align = 'center', -- *optionally* specify an alignment (either 'left', 'center', or 'right')
			},
			-- Or, specify the event which the sidebar executes when leaving:
			['neo-tree'] = {event = 'BufWipeout'},
			-- Or, specify all three
			Outline = {event = 'BufWinLeave', text = 'symbols-outline', align = 'right'},
		},

		-- New buffer letters are assigned in this order. This order is
		-- optimal for the qwerty keyboard layout but might need adjustment
		-- for other layouts.
		letters = 'asdfjklöghnmxcvbyiowerutzqpASDFJKLGHNMXCVBYIOWERUTZQP',

		-- Sets the name of unnamed buffers. By default format is "[Buffer X]"
		-- where X is the buffer number. But only a static string is accepted here.
		no_name_title = "NO NAME",
	},
	keys = {
		{ "ö", "<Cmd>BufferPick<CR>", desc = "Barbar magic pick" },
		{ "H", "<Cmd>BufferPrevious<CR>", desc = "Prev tab" },
		{ "L", "<Cmd>BufferNext<CR>", desc = "Next tab" },
	},
	init = function() vim.g.barbar_auto_setup = false end,
}
