local coqSettings = {
	auto_start = true,
	keymap = {
		recommended = false,
		manual_complete = nil,
		bigger_preview = nil,
		jump_to_mark = nil
	},
	display = {
		["icons.mappings"] = {
			Text = "",
			Method = "󰆧",
			Function = "󰊕",
			Constructor = "",
			Field = "󰜢",
			Variable = "󰀫",
			Class = "󰠱",
			Interface = "󰜰",
			Module = "󰋽",
			Property = "󰠖",
			Unit = "󰑭",
			Value = "#",
			Enum = "󰒻",
			Keyword = "󰌋",
			Snippet = "󰘍",
			Color = "󰏘",
			File = "󰈙",
			Reference = "󰌹",
			Folder = "󰉋",
			EnumMember = "󰒽",
			Constant = "󰎠",
			Struct = "󰙅",
			Event = "󰙸",
			Operator = "󰆕",
			TypeParameter = "󰊄",
		},
		["icons.mode"] = "short",
		["pum.kind_context"] = { " ", "" },
		["pum.source_context"] = { "", "" },
	},
}

if vim.g.lazyvim_cmp == "coq_nvim" then
	vim.api.nvim_set_keymap(
		"i",
		"<CR>",
		[[pumvisible() ? (complete_info().selected == -1 ? "\<C-n><C-y>" : "\<C-y>") : "\<CR>"]],
		{ expr = true, noremap = true }
	)
	vim.g.coq_settings = coqSettings
end

return {}
