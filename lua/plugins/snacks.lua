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
	opts = {
		bigfile = { enabled = true },
		indent = { enabled = false },
		input = { enabled = true },
		quickfile = { enabled = true },
		notifier = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
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
	},
}
