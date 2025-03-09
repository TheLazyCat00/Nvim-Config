return {
	"echasnovski/mini.indentscope",
	version = false, -- wait till new 0.7.0 release to put it back on semver
	event = "LazyFile",
	opts = {
		-- symbol = "▏",
		symbol = " ",
		options = { try_as_border = false },
		draw = {
			-- animation = function()
			-- 	return 0
			-- end,
			-- delay = 0,
			predicate = function (scope)
				return false
			end,
			priority = 0
		}
	},
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"Trouble",
				"alpha",
				"dashboard",
				"fzf",
				"help",
				"lazy",
				"mason",
				"neo-tree",
				"notify",
				"snacks_dashboard",
				"snacks_notif",
				"snacks_terminal",
				"snacks_win",
				"toggleterm",
				"trouble",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "SnacksDashboardOpened",
			callback = function(data)
				vim.b[data.buf].miniindentscope_disable = true
			end,
		})
	end,
}
