local installedLanguages = {
	"bash",
	"c",
	"cpp",
	"c_sharp",
	"cmake",
	"d",
	"diff",
	"dart",
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

return {
	"nvim-treesitter/nvim-treesitter",
	version = false, -- last release is way too old and doesn't work on Windows
	build = ":TSUpdate",
	event = { "LazyFile", "VeryLazy" },
	lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
	---@type TSConfig
	---@diagnostic disable-next-line: missing-fields
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	opts = {
		ensure_installed = installedLanguages,
	}
}
