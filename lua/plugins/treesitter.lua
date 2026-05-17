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

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*.y",
	callback = function(ev)
		vim.notify("hi")
		-- Force bison as the TS language (matches what you tested)
		pcall(vim.treesitter.start, ev.buf, "bison")
	end,
})

vim.treesitter.language.register("bison", "yacc")
vim.api.nvim_create_autocmd('User', {
	pattern = 'TSUpdate',
	callback = function()
		require('nvim-treesitter.parsers').coda = {
			install_info = {
				url = 'https://github.com/zane-lang/tree-sitter-coda',
				queries = "queries",
			},
		}
		require("nvim-treesitter.parsers").bison = {
			install_info = {
				url = "https://github.com/lemonadern/tree-sitter-bison",
				branch = "master",
			}
		}
	end,
})

return {
	"nvim-treesitter/nvim-treesitter",
	version = false, -- last release is way too old and doesn't work on Windows
	lazy = false,
	build = ":TSUpdate",
	---@type TSConfig
	---@diagnostic disable-next-line: missing-fields
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	opts = {
		ensure_installed = installedLanguages,
	}
}
