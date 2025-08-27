local installedLanguages = {
	"bash",
	"c",
	"cpp",
	"c_sharp",
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
	version = false, -- last release is way too old and doesn't work on Windows
	build = ":TSUpdate",
	event = { "LazyFile", "VeryLazy" },
	lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    -- no longer trigger the **nvim-treesitter** module to be loaded in time.
    -- Luckily, the only things that those plugins need are the custom queries, which we make available
    -- during startup.
    require("lazy.core.loader").add_to_rtp(plugin)
    require("nvim-treesitter.query_predicates")
  end,
	---@type TSConfig
	---@diagnostic disable-next-line: missing-fields
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	opts = {
		ensure_installed = installedLanguages,
	}
}
