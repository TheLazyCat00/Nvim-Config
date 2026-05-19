vim.g.neovide_position_animation_length = 0.1
vim.g.neovide_cursor_short_animation_length = 0.1
vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_cursor_animation_length = 0.1
vim.g.neovide_cursor_trail_size = 0.6
vim.g.neovide_hide_mouse_when_typing = false

local function getMaxRefreshRate()
	local osName = vim.loop.os_uname().sysname
	local handle, result

	if osName == "Linux" then
		-- Try Wayland first (wlr-randr), fall back to X11 (xrandr)
		handle = io.popen("command -v wlr-randr >/dev/null 2>&1 && wlr-randr | grep -oP '\\d+\\.?\\d*(?=Hz)' | sort -nr | head -n 1 || xrandr | grep '*' | awk '{print $2}' | sort -nr | head -n 1")
	elseif osName == "Darwin" then
		-- macOS
		handle = io.popen("system_profiler SPDisplaysDataType | grep 'Resolution' -A 1 | grep 'Refresh Rate' | awk '{print $3}' | sort -nr | head -n 1")
	elseif osName == "Windows_NT" then
		-- Windows (PowerShell)
		handle = io.popen('powershell -command "(Get-WmiObject -Class Win32_VideoController).CurrentRefreshRate | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum"')
	else
		return nil, "Unsupported OS"
	end

	if handle then
		result = handle:read("*a")
		handle:close()
		return tonumber(result:match("%d+")), nil
	else
		return nil, "Failed to detect refresh rate"
	end
end

local function setNeovideRefreshRate()
	local maxRate, err = getMaxRefreshRate()
	if maxRate then
		vim.g.neovide_refresh_rate = maxRate
		vim.notify("Neovide refresh rate set to: " .. maxRate .. "Hz")
	else
		vim.notify("Warning: " .. (err or "Could not detect refresh rate. Using default."))
	end
end

setNeovideRefreshRate()
