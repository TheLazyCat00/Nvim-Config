return {
	"saghen/blink.cmp",
	enabled = vim.g.lazyvim_cmp == "blink",
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
					score_offset = 4
				}
			}
		}
	}
}
