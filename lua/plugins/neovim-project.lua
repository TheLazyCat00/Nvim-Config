return {
	"coffebar/neovim-project",
	enabled = vim.g.project_manager == "neovim-project",
	lazy = false,
	opts = {
		projects = {
			"main.*",
			"*/.git/",
			"_darcs",
			".hg",
			".bzr",
			".svn",
			"Makefile",
			"package.json",
			"LICENSE.txt",
			".gitignore",
			"README.*",
		},
		picker = {
			type = "telescope", -- or "fzf-lua"
			preview = true, -- show directory structure preview in Telescope
		}
	},
	init = function()
		-- enable saving the state of plugins in the session
		vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
	end,
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		-- optional picker
		-- optional picker
		{ "Shatur/neovim-session-manager" },
	},
}
