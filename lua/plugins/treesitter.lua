local installedLanguages = {
	"bash",
	"bison",
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
	"zane",
}

local indentDisabled = { ocaml = true }

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- main doesn't support lazy-loading
		build = ":TSUpdate",
		init = function()
			-- Registered in init so it exists before the first install or :TSUpdate,
			-- both of which fire this event before reading the parser table.
			vim.api.nvim_create_autocmd("User", {
				pattern = "TSUpdate",
				callback = function()
					local parsers = require("nvim-treesitter.parsers")
					parsers.coda = {
						install_info = {
							url = "https://github.com/zane-lang/tree-sitter-coda",
							queries = "queries",
						},
					}
					parsers.zane = {
						install_info = {
							url = "https://github.com/zane-lang/compiler",
							location = "editors/tree-sitter-zane",
							generate = true,
							generate_from_json = false,
							queries = "editors/tree-sitter-zane/queries",
						},
					}
					parsers.bison = {
						install_info = {
							url = "https://github.com/lemonadern/tree-sitter-bison",
							branch = "master",
						},
					}
				end,
			})

			-- Filetypes that use another filetype's parser.
			vim.treesitter.language.register("bison", "yacc") -- *.y files are filetype yacc
			vim.treesitter.language.register("cpp", "elkhound")
		end,
		config = function()
			-- Only installs what's missing; runs in the background.
			require("nvim-treesitter").install(installedLanguages)

			-- main has no highlight/indent modules; enable them per buffer.
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					if not pcall(vim.treesitter.start, args.buf) then
						return -- no parser for this filetype
					end
					if not indentDisabled[vim.bo[args.buf].filetype] then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
	{
		-- Zane filetype detection, the zane-bound? predicate and the "; extends" query.
		"zane-lang/compiler",
		name = "zane.nvim",
		lazy = false,
		config = function(plugin)
			vim.opt.rtp:append(plugin.dir .. "/editors/neovim")
			dofile(plugin.dir .. "/editors/neovim/zane.lua")
		end,
	},
}
