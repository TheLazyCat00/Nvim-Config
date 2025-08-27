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
	lazy = false,
	---@type snacks.Config
	opts = function ()
		Toggler = {}
		Toggler.__index = Toggler

		function Toggler.new(mode, lhs, rhs, name, startValue)
			startValue = startValue or false

			local self = setmetatable({}, Toggler)
			self.toggled = startValue

			local toggler = Snacks.toggle.new({
				get = function()
					return self.toggled
				end,
				set = function()
					self.toggled = not self.toggled
					local keys = vim.api.nvim_replace_termcodes(rhs, true, false, true)
					vim.api.nvim_feedkeys(keys, mode, false)
				end,
				name = name,
			})

			toggler:map(lhs)
		end

		return {
			animate = { enabled = false },
			image = { enabled = false },
			indent = { enabled = false },
			scroll = { enabled = false },
			scope = { enabled = false },
			rename = { enabled = false },
			bufdelete = { enabled = false },

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
						{ icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
						{ icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
						{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
						(function ()
							if vim.g.neovide then
								return
									{ icon = " ", key = "r", desc = "Restore Session", action = ":lua require('recent-dirs').open_buffer(1)" },
									{ icon = " ", key = "o", desc = "Recent Projects", action = ":lua require('recent-dirs').pick()" }
							else
								return nil
							end
						end)(),
					},
				},
			}
		}
	end,
}
