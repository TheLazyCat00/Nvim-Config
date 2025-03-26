local wholeImage =
[[
                                                                        
           ████ ██████           █████      ██                    
          ███████████             █████                            
          █████████ ███████████████████ ███   ███████████  
         █████████  ███    █████████████ █████ ██████████████  
        █████████ ██████████ █████████ █████ █████ ████ █████  
      ███████████ ███    ███ █████████ █████ █████ ████ █████ 
     ██████  █████████████████████ ████ █████ █████ ████ ██████
]]

return {
	"folke/snacks.nvim",
	---@type snacks.Config
	opts = function ()
		-- Toggle the profiler
		Snacks.toggle.profiler():map("<leader>pp")
		-- Toggle the profiler highlights
		Snacks.toggle.profiler_highlights():map("<leader>ph")
		local restore_session = ""
		if vim.g.project_manager == "project.nvim" then
			restore_session = ":lua require'telescope'.extensions.projects.projects{}"
		elseif vim.g.project_manager  == "neovim-project" then
			restore_session = ":NeovimProjectHistory"
		elseif vim.g.project_manager == "persistence.nvim" then
			restore_session = ":lua require('persistence').select()"
		end

		local continue = {}
		if vim.g.project_manager == "persistence.nvim" then
			continue = { icon = "󰠜 ", key = "<leader>", desc = "Continue", action = ":lua require('persistence').load({ last = true })" }
		end

		return {
			animate = { enabled = false },
			image = { enabled = false },
			indent = { enabled = false },
			scroll = { enabled = false },
			scope = { enabled = false },
			rename = { enabled = false },

			notifier = { enabled = true },
			profiler = { enabled = true },
			bigfile = { enabled = true },
			input = { enabled = true },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			lazygit = { enabled = true },
			zen = { enabled = true },

			dashboard = {
				enabled = true,
				preset = {
					header = wholeImage,
					keys = {
						continue,
						{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
						{ icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
						{ icon = " ", key = "s", desc = "Restore Session", action = restore_session },
						{ icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
						{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
			}
		}
	end,
	keys = {
		{ "<leader>ps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Bufer" },
	}
}
