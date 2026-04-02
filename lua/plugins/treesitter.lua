local installedLanguages = {
	"bash",
	"c",
	"cpp",
	"c_sharp",
	"coda",
	"cmake",
	"d",
	"diff",
	"dart",
	"go",
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
	"ocaml",
	"printf",
	"python",
	"powershell",
	"query",
	"regex",
	"rust",
	"toml",
	"tsx",
	"typescript",
	"scss",
	"vim",
	"vimdoc",
	"vue",
	"xml",
	"yaml",
}

vim.api.nvim_create_autocmd('User', {
	pattern = 'TSUpdate',
	callback = function()
		require('nvim-treesitter.parsers').coda = {
			install_info = {
				url = 'https://github.com/zane-lang/tree-sitter-coda',
				queries = "queries",
			},
		}
	end,
})

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
