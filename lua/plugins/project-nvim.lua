return {
	"ahmedkhalf/project.nvim",
	event = "VeryLazy",
	opts = {
		-- Manual mode doesn't automatically change your root directory, so you have
		-- the option to manually do so using `:ProjectRoot` command.
		manual_mode = false,

		-- Methods of detecting the root directory. **"lsp"** uses the native neovim
		-- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
		-- order matters: if one is not detected, the other is used as fallback. You
		-- can also delete or rearangne the detection methods.
		detection_methods = { "lsp", "pattern" },

		-- All the patterns used to detect root dir, when **"pattern"** is in
		-- detection_methods
		patterns = { "main.*", ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "LICENSE.txt", ".gitignore", "README.*" },

		-- Table of lsp clients to ignore by name
		-- eg: { "efm", ... }
		ignore_lsp = {},

		-- Don't calculate root dir on specific directories
		-- Ex: { "~/.cargo/*", ... }
		exclude_dirs = {},

		-- Show hidden files in telescope
		show_hidden = false,

		-- When set to false, you will get a message when project.nvim changes your
		-- directory.
		silent_chdir = true,

		-- What scope to change the directory, valid options are
		-- * global (default)
		-- * tab
		-- * win
		scope_chdir = 'global',

		-- Path where project.nvim will store the project history for use in
		-- telescope
		datapath = vim.fn.stdpath("data"),
	},
	config = function (_, opts)
		require("project_nvim").setup(opts)
		require('telescope').load_extension('projects')

		vim.defer_fn(function ()
			local recent_projects = require("project_nvim").get_recent_projects()

			if #recent_projects > 0 then
				local latest_project = recent_projects[#recent_projects]
				print("Switching to recent project: " .. latest_project)
				vim.cmd("cd " .. vim.fn.fnameescape(latest_project))
			end
		end, 100)
	end,
	keys = {
		{
			"so", function ()
				require'telescope'.extensions.projects.projects{}
			end,
			desc = "Open Sessions"
		}
	}
}
