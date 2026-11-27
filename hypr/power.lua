-- Automatically adjust built-in display refresh rate based on AC/battery state.

local M = {}

local builtin_monitor, ac_mode, battery_mode

function M.set_on_battery(on_battery)
	if not builtin_monitor then
		return
	end
	local mode = on_battery and battery_mode or ac_mode
	if builtin_monitor.mode == mode then
		return
	end
	builtin_monitor.mode = mode
	local mon = hl.get_monitor(builtin_monitor.output)
	if mon and mon.enabled ~= false then
		hl.monitor(builtin_monitor)
	end
end

function M.setup(monitor_spec, bat_mode)
	builtin_monitor = monitor_spec
	ac_mode = monitor_spec.mode
	battery_mode = bat_mode

	hl.on("config.reloaded", function()
		hl.exec_cmd("$HOME/.config/hypr/scripts/upower-sync.sh")
	end)
end

return M
