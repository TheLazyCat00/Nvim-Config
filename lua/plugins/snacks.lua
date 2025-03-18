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
		return {
			animate = { enabled = false },
			explorer = { enabled = false },
			image = { enabled = false },
			indent = { enabled = false },
			scroll = { enabled = false },
			picker = { enabled = false },
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
			dashboard = {
				enabled = true,
				preset = {
					header = wholeImage,
					keys = {
						{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
						{ icon = "󰠜 ", key = "d", desc = "Continue", section = "session"},
						{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
						{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
						{ icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
						{ icon = " ", key = "s", desc = "Restore Session", action = ":lua require'telescope'.extensions.projects.projects{}" },
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
