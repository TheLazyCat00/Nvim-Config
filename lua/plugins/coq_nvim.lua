local coqSettings = {
	auto_start = true,
	keymap = {
		recommended = false,
		manual_complete = "",
		bigger_preview = "",
		jump_to_mark = "<Tab>",
	},
	clients = {
		snippets = {
			always_on_top = true
		},
	},
	completion = {
		skip_after = { " ", "	", "{", "[", "(", ")", "]", "}" },
	},
	display = {
		["icons.mappings"] = {
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
		},
		["icons.mode"] = "short",
		["pum.kind_context"] = { " ", "" },
		["pum.source_context"] = { "", "" },
	},
}

if vim.g.lazyvim_cmp == "coq_nvim" then
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "codecompanion",
		callback = function (args)
			vim.keymap.set("i", "/", function()
				vim.cmd("normal! i/")
				vim.cmd("stopinsert")
				vim.api.nvim_input("la<C-_>")
			end, { noremap = true, buffer = true })

			vim.keymap.set("i", "@", function()
				vim.cmd("normal! i@")
				vim.cmd("stopinsert")
				vim.api.nvim_input("la<C-_>")
			end, { noremap = true, buffer = true })
		end
	})

	vim.api.nvim_set_keymap(
		"i",
		"<CR>",
		[[pumvisible() ? (complete_info().selected == -1 ? "\<C-n><C-y>" : "\<C-y>") : "\<CR>"]],
		{ expr = true, noremap = true }
	)
	vim.api.nvim_set_keymap(
		"i",
		"<Tab>",
		[[pumvisible() ? (complete_info().selected == -1 ? "\<C-n><C-y>" : "\<C-y>") : "\<CR>"]],
		{ expr = true, noremap = true }
	)
	vim.g.coq_settings = coqSettings
end

return {}
