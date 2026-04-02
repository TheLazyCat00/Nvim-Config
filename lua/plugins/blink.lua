return {
	"saghen/blink.cmp",
	enabled = vim.g.lazyvim_cmp == "blink.cmp",
	opts = {
		appearance = {
			kind_icons = {
				Text = '󰉿',
				Method = '󰊕',
				Function = '󰊕',
				Constructor = '󰒓',

				Field = '󰜢',
				Variable = '󰆦',
				Property = '󰖷',

				Class = '󱡠',
				Interface = '󱡠',
				Struct = '󱡠',
				Module = '󰅩',

				Unit = '󱓉',
				Value = '󰦨',
				Enum = '󰦨',
				EnumMember = '󰦨',

				Keyword = '󰻾',
				Constant = '󰏿',

				Snippet = '󱄽',
				Color = '󰏘',
				File = '󰈔',
				Reference = '󰬲',
				Folder = '󰉋',
				Event = '󱐋',
				Operator = '󱓉',
				TypeParameter = '󰬛',
			}
		},
		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
		sources = {
			providers = {
				snippets = {
					-- defaults:
					-- lsp: 0
					-- snippets: -1
					-- path: 3
					-- buffer: -3
					score_offset = - 0.2
				}
			}
		}
	}
}
