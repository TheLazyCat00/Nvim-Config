local explorer = {
	finder = "explorer",
	sort = {
		fields = { "score:desc", "#text", "idx" },
	},
	supports_live = true,
	tree = false,
	watch = true,
	diagnostics = true,
	diagnostics_open = false,
	git_status = true,
	git_status_open = false,
	git_untracked = true,
	follow_file = true,
	focus = "input",
	auto_close = true,
	jump = { close = true },
	layout = { preset = "default", preview = true },
	-- to show the explorer to the right, add the below to
	-- your config under `opts.picker.sources.explorer`
	-- layout = { layout = { position = "right" } },
	--
	formatters = {
		file = { filename_only = true },
		severity = { pos = "right" },
	},
	matcher = {
		sort_empty = false, -- sort even when the filter is empty
		fuzzy = true,
	},
	config = function(opts)
		return require("snacks.picker.source.explorer").setup(opts)
	end,
	actions = {
		---@param picker snacks.Picker
		---@param item snacks.picker.Item
		change_cwd = function (picker, item)
			pcall(function ()
				vim.fn.chdir(item.file)
			end)
		end
	},
	win = {
		input = {
			keys = {
				["<BS>"] = "explorer_up",
				["<CR>"] = { "jump", mode = { "n", "i" }},
				["<c-a>"] = { "explorer_add", mode = { "n", "i" }},
				["<c-x>"] = { "explorer_del", mode = { "n", "i" }},
				["<c-r>"] = { "explorer_rename", mode = { "n", "i" }},
				["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
				["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" }},
				["<c-w>"] = { "change_cwd", mode = { "i", "n" }},
			}
		},
		list = {
			keys = {
				["<BS>"] = "explorer_up",
				["<CR>"] = "confirm",
				["h"] = "explorer_close", -- close directory
				["a"] = "explorer_add",
				["d"] = "explorer_del",
				["r"] = "explorer_rename",
				["c"] = "explorer_copy",
				["m"] = "explorer_move",
				["o"] = "explorer_open", -- open with system application
				["y"] = { "explorer_yank", mode = { "n", "x" } },
				["p"] = "explorer_paste",
				["u"] = "explorer_update",
				["<c-c>"] = "tcd",
				["<leader>/"] = "picker_grep",
				["<c-t>"] = "terminal",
				["."] = "explorer_focus",
				["I"] = "toggle_ignored",
				["H"] = "toggle_hidden",
				["Z"] = "explorer_close_all",
				["]g"] = "explorer_git_next",
				["[g"] = "explorer_git_prev",
				["]d"] = "explorer_diagnostic_next",
				["[d"] = "explorer_diagnostic_prev",
				["]w"] = "explorer_warn_next",
				["[w"] = "explorer_warn_prev",
				["]e"] = "explorer_error_next",
				["[e"] = "explorer_error_prev",
			},
		},
	},
}

return {
	"folke/snacks.nvim",
	opts = {
		explorer = {},
		picker = {
			sources = {
				explorer = explorer
			},
			win = {
				input = {
					keys = {
						["f"] = "focus_list",
						["t"] = "focus_preview",
						["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
						["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" }},
					}
				},
				list = {
					keys = {
						["f"] = "focus_input",
						["t"] = "focus_preview",
					},
				},
				preview = {
					keys = {
						["f"] = "focus_list",
						["t"] = "focus_input",
					}
				}
			},
		},
	},
	keys = {
		{ "<leader>fc", function () Snacks.explorer({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
		{ "<leader>e", false },
		{ "<leader>E", false },
		{ "<leader>fE", false },
		{ "<leader>fe", function() Snacks.explorer({ cwd = LazyVim.root() }) end, desc = "File Explorer (root)" },
		{ "<leader><space>", function() Snacks.explorer() end, desc = "File Explorer (cwd)" },
		{ "<leader>fp", false },
	},
}
