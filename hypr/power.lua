-- Automatically adjust built-in display refresh rate based on AC/battery state.

local M = {}

local find_builtin = nil
local battery_hz = 60

function M.set_on_battery(on_battery)
	local mon = find_builtin and find_builtin() or nil
	if not mon or mon.enabled == false then
		return
	end

	local mode = on_battery and string.format("%dx%d@%d", mon.width, mon.height, battery_hz) or "preferred"
	hl.monitor({
		output = mon.name,
		mode = mode,
		position = string.format("%dx%d", mon.x, mon.y),
		scale = mon.scale,
	})
end

function M.setup(builtin_finder, opts)
	find_builtin = builtin_finder
	battery_hz = (opts and opts.battery_hz) or 60

	hl.on("monitor.added", function()
		hl.exec_cmd("$HOME/.config/hypr/scripts/upower-sync.sh")
	end)

	hl.on("config.reloaded", function()
		hl.exec_cmd("$HOME/.config/hypr/scripts/upower-sync.sh")
	end)
end

return M
