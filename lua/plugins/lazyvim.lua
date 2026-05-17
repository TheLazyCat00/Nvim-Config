return {
	"LazyVim/LazyVim",
	lazy = false,
	version = "*",
	-- opts.* corresponds to LazyVim.config.*
	-- https://www.lazyvim.org/configuration#default-settings
	opts = {
		colorscheme = "kanagawa",
		defaults = {
			autocmds = true,
			keymaps = true,
		},
		icons = {
			dap = {
				Breakpoint = " ",
				BreakpointCondition = " ",
				BreakpointRejected = { " ", "DiagnosticError" },
				LogPoint = ".>",
				Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" }
			},
			diagnostics = {
				Error = " ",
				Hint = " ",
				Info = " ",
				Warn = " "
			},
			ft = {
				gh = " ",
				["markdown.gh"] = " ",
				octo = " "
			},
			git = {
				added = " ",
				modified = " ",
				removed = " "
			},
			kinds = {
				-- Blink recommended
				Text = "󰉿",
				Method = "󰊕",
				Function = "󰊕",
				Constructor = "󰒓",
				Field = "󰜢",
				Variable = "󰆦",
				Property = "󰖷",
				Class = "󱡠",
				Interface = "󱡠",
				Struct = "󱡠",
				Module = "󰅩",
				Unit = "",
				Value = "󰦨",
				Enum = "󰦨",
				EnumMember = "󰦨",
				Keyword = "󰻾",
				Constant = "󰏿",
				Snippet = "󱄽",
				Color = "󰏘",
				File = "󰈔",
				Reference = "󰬲",
				Folder = "󰉋",
				Event = "󱐋",
				Operator = "󱓉",
				TypeParameter = "󰬛",

				-- From rest
				Array = "",
				Boolean = "󰨙",
				Codeium = "󰘦",
				Collapsed = "",
				Control = "",
				Copilot = "",
				Key = "",
				Namespace = "󰦮",
				Null = "",
				Number = "󰎠",
				Object = "",
				Package = "",
				String = "",
				Supermaven = "",
				TabNine = "󰏚",
			},
			misc = {
				dots = "󰇘"
			}
		},
	},
}
