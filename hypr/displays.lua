-- Automatic workspace movement to accomodate external displays or laptop lid opening/closure.

local M = {}

local saved_builtin_spec = nil
local display_sync_timer = nil
local persistent_rules = {}

local function is_lid_closed()
	local f = io.open("/proc/acpi/button/lid/LID0/state", "r") or io.open("/proc/acpi/button/lid/LID/state", "r")
	if not f then
		return false
	end
	local content = f:read("*a") or ""
	f:close()
	return content:find("closed", 1, true) ~= nil
end

local function is_builtin_monitor(mon)
	return mon ~= nil and mon.name ~= nil and mon.name:match("^eDP") ~= nil
end

local function is_real_monitor(mon)
	return mon and mon.enabled ~= false and not mon.is_mirror and mon.name ~= nil and not mon.name:match("^FALLBACK")
end

local function get_active_monitors()
	local monitors = {}
	for _, mon in ipairs(hl.get_monitors()) do
		if is_real_monitor(mon) then
			table.insert(monitors, mon)
		end
	end
	table.sort(monitors, function(a, b)
		local a_builtin = is_builtin_monitor(a)
		local b_builtin = is_builtin_monitor(b)
		if a_builtin ~= b_builtin then
			return a_builtin
		end
		if a.id ~= b.id then
			return a.id < b.id
		end
		return a.name < b.name
	end)
	return monitors
end

local function has_external_monitor()
	for _, mon in ipairs(hl.get_monitors()) do
		if is_real_monitor(mon) and not is_builtin_monitor(mon) then
			return true
		end
	end
	return false
end

function M.find_builtin()
	for _, mon in ipairs(hl.get_monitors({ all = true })) do
		if mon and not mon.is_mirror and is_builtin_monitor(mon) then
			return mon
		end
	end
	return nil
end

local function is_builtin_enabled()
	local mon = M.find_builtin()
	return mon ~= nil and mon.enabled ~= false
end

local function apply_builtin_monitor(enabled)
	local mon = M.find_builtin()
	if not mon then
		return
	end
	if enabled then
		hl.monitor(saved_builtin_spec or { output = mon.name, mode = "preferred", position = "auto", scale = "auto" })
		return
	end
	if mon.enabled ~= false then
		saved_builtin_spec = {
			output = mon.name,
			mode = string.format("%dx%d@%.0f", mon.width, mon.height, mon.refresh_rate),
			position = string.format("%dx%d", mon.x, mon.y),
			scale = mon.scale,
		}
	end
	hl.monitor({ output = mon.name, disabled = true })
end

local function sync_lid_state()
	local should_disable = is_lid_closed() and has_external_monitor()
	local builtin_on = is_builtin_enabled()

	if should_disable and builtin_on then
		apply_builtin_monitor(false)
		return true
	elseif not should_disable and not builtin_on then
		apply_builtin_monitor(true)
		return true
	end

	return false
end

local function sync_persistent_workspaces(count)
	for id = 1, count do
		if not persistent_rules[id] then
			persistent_rules[id] = hl.workspace_rule({ workspace = tostring(id), persistent = true })
		else
			persistent_rules[id]:set_enabled(true)
		end
	end
	for id, rule in pairs(persistent_rules) do
		if id > count then
			rule:set_enabled(false)
		end
	end
end

function M.redistribute()
	local monitors = get_active_monitors()
	local n = #monitors
	if n == 0 then
		return
	end

	-- Don't place workspaces on the built-in display while the lid is closed if external displays are available.
	if is_lid_closed() and n > 1 then
		local external = {}
		for _, mon in ipairs(monitors) do
			if not is_builtin_monitor(mon) then
				table.insert(external, mon)
			end
		end
		if #external > 0 then
			monitors = external
			n = #monitors
		end
	end

	sync_persistent_workspaces(math.min(n * 3, 10))

	local prev_ws = hl.get_active_workspace()
	local prev_ws_id = prev_ws and prev_ws.id or nil

	local workspaces = {}
	for _, ws in ipairs(hl.get_workspaces()) do
		if not ws.special and ws.id and ws.id >= 1 then
			table.insert(workspaces, ws)
		end
	end
	table.sort(workspaces, function(a, b)
		return a.id < b.id
	end)

	local first_nonempty_for_monitor = {}
	for _, ws in ipairs(workspaces) do
		local target_idx = (ws.id % n) + 1
		local target_mon = monitors[target_idx]
		if not ws.is_empty and not first_nonempty_for_monitor[target_mon.name] then
			first_nonempty_for_monitor[target_mon.name] = ws.id
		end
		if not ws.monitor or ws.monitor.name ~= target_mon.name then
			hl.dispatch(hl.dsp.workspace.move({ workspace = ws.id, monitor = target_mon.name }))
		end
	end

	-- Prefer showing a non-empty workspace on monitors that received one.
	for _, mon in ipairs(monitors) do
		local active = hl.get_active_workspace(mon.name)
		local candidate = first_nonempty_for_monitor[mon.name]
		if candidate and (not active or (active.is_empty and not active.is_persistent)) then
			hl.dispatch(hl.dsp.focus({ workspace = candidate }))
		end
	end

	if prev_ws_id and hl.get_workspace(prev_ws_id) then
		hl.dispatch(hl.dsp.focus({ workspace = prev_ws_id }))
	end
end

-- Debounce helper
local function schedule_display_sync(delay_ms)
	if display_sync_timer then
		display_sync_timer:set_enabled(false)
		display_sync_timer = nil
	end
	display_sync_timer = hl.timer(function()
		display_sync_timer = nil
		M.sync()
	end, { timeout = delay_ms or 200, type = "oneshot" })
end

function M.sync()
	local changed = sync_lid_state()
	if changed then
		schedule_display_sync(200)
		return
	end
	M.redistribute()
end

function M.setup()
	if is_lid_closed() and has_external_monitor() then
		apply_builtin_monitor(false)
	end

	hl.bind("switch:on:Lid Switch", function()
		if has_external_monitor() then
			apply_builtin_monitor(false)
			schedule_display_sync(200)
		end
	end, { locked = true, description = "Disable built-in display on lid close" })

	hl.bind("switch:off:Lid Switch", function()
		apply_builtin_monitor(true)
		schedule_display_sync(200)
	end, { locked = true, description = "Enable built-in display on lid open" })

	for _, event in ipairs({
		"monitor.added",
		"monitor.removed",
		"monitor.layout_changed",
		"hyprland.start",
		"config.reloaded",
	}) do
		hl.on(event, function()
			schedule_display_sync(200)
		end)
	end

	hl.on("config.unload", function()
		if display_sync_timer then
			display_sync_timer:set_enabled(false)
			display_sync_timer = nil
		end
	end)

	schedule_display_sync(200)
end

return M
