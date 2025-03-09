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
				header = wholeImage
			}
		}
	},
}
