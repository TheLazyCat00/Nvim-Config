local installedLanguages = {
	"bash",
	"c",
	"cpp",
	"cmake",
	"diff",
	"html",
	"javascript",
	"java",
	"julia",
	"jsdoc",
	"json",
	"jsonc",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"printf",
	"python",
	"powershell",
	"query",
	"regex",
	"rust",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"vue",
	"xml",
	"yaml",

}

-- Define keymaps for "around node" (an) and "inside node" (in)
vim.keymap.set({'o', 'x'}, 'aö', function()
  require('nvim-treesitter.textobjects.select').select_textobject('@node.outer')
end, {desc = 'Around node'})

vim.keymap.set({'o', 'x'}, 'iö', function()
  require('nvim-treesitter.textobjects.select').select_textobject('@node.inner')
end, {desc = 'Inside node'})

return {
	"nvim-treesitter/nvim-treesitter",
	---@type TSConfig
	---@diagnostic disable-next-line: missing-fields
	opts = {
		ensure_installed = installedLanguages,
	}
}
