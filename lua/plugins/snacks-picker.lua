local explorer = {
	finder = "explorer",
	sort = {
		fields = { "score:desc", "#text", "idx" },
	},
	show_empty = true,
	hidden = true,
	ignored = false,
	follow = false,
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

local function getDirectorySelector()
	local maxResults = 50
	local maxDepth = 4
	---@type snacks.picker.Config
	return {
		live = true,
		finder = function(config, ctx)
			local items = {{
				file = "..",
				dir = true,
			}}

			local dirs = vim.fn.systemlist({
				"fd",
				"--type", "d",
				"--max-results", maxResults,
				"--max-depth", maxDepth,
				ctx.picker.input:get()
			}, ctx:cwd())

			if vim.v.shell_error ~= 0 then
				return items
			end

			for _, dir in ipairs(dirs) do
				items[#items + 1] = {
					file = dir,
					dir = true,
				}
			end

			return items
		end,
		format = "file",
		preview = "file",
		title = "Directories",
		sort = {
			fields = { "score:desc", "#text", "idx" },
		},
		show_empty = true,
		hidden = true,
		ignored = true,
		follow = false,
		jump = { close = true },
		layout = { preset = "default", preview = true },
		formatters = {
			file = { filename_only = true },
			severity = { pos = "right" },
		},
		matcher = {
			sort_empty = true, -- sort even when the filter is empty
			fuzzy = true,
		},
		actions = (function()
			---@param picker snacks.Picker
			local function changeCwd(cwd, picker)
				cwd = picker:cwd() .. "/" .. cwd
				picker:set_cwd(cwd)
				pcall(function ()
					vim.fn.chdir(cwd)
				end)
				picker:refresh()
			end

			--- @alias PickerAction fun(picker: snacks.Picker, item: snacks.picker.Item)
			--- @type table<string, PickerAction>
			return {
				change_cwd = function(picker, item)
					changeCwd(item.file, picker)
				end,
				up = function(picker, item)
					picker:set_cwd(picker:cwd() .. "/" .. item.file)
					picker:refresh()
				end,
				confirm = function(picker, item)
					changeCwd(item.file, picker)
					picker:close()
					Snacks.explorer()
				end,
			}
		end)(),
		win = {
			input = {
				keys = {
					["<BS>"] = "up",
					["<CR>"] = { "confirm", mode = { "n", "i" } },
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
					["<BS>"] = "up",
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
end

return {
	"folke/snacks.nvim",
	opts = {
		explorer = {},
		picker = {
			sources = {
				explorer = explorer,
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
		{ "<leader><space>", function() Snacks.explorer() end, desc = "File Explorer (cwd)" },
		{ "<leader>fe", function() Snacks.explorer({ cwd = LazyVim.root() }) end, desc = "File Explorer (root)" },
		{ "<leader>fd", function() Snacks.picker.pick(getDirectorySelector()) end, desc = "Directory Selector (cwd)" },
		{ "<leader>fp", false },
	},
}
