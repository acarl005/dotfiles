----------------
--- MONITORS ---
----------------

-- See https://wiki.hypr.land/configuring/core/monitors/

-- ASUS Zephyrus G16 display
hl.monitor({
	output = "desc:Samsung Display Corp. ATNA60DL01-0",
	mode = "2560x1600",
	position = "0x0",
	scale = 1.6,
})
hl.monitor({
	output = "desc:Samsung Electric Company LC27G7xT H4ZR501928",
	mode = "2560x1440",
	position = "-1120x-1440",
	scale = 1.0,
})
hl.monitor({
	output = "desc:BNQ BenQ SW271 A7L01657SL0",
	mode = "3840x2160",
	position = "1440x-1440",
	scale = 1.5,
})

local displays = require("displays")
displays.setup()
require("power").setup(displays.find_builtin)

-----------------
--- AUTOSTART ---
-----------------

-- See https://wiki.hypr.land/configuring/core/autostart/

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("waybar")
	hl.exec_cmd("fcitx5")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("$HOME/.config/hypr/scripts/upower-watch.sh")
	hl.exec_cmd("swaync")
	hl.exec_cmd("swayosd-server")
	hl.exec_cmd("qs -c alt-tab")
	hl.exec_cmd("qs -c cheatsheet -n")
	hl.exec_cmd(
		'nwg-dock-hyprland -d -hd 0 -i 32 -mb 8 -w 10 -ico "$HOME/.config/nwg-dock-hyprland/grid.svg" -g "wofi org.quickshell quickshell" -c "wofi --allow-images --normal-window --no-actions --show drun"'
	)
	-- TODO: do this better.
	-- There's some race condition happening here where the `blueman-applet` depends on something else
	-- initializing first in order to register itself as the auth agent. Might be the
	-- `blueman-mechanism.service` but I'm not sure, so just sleep for a bit.
	hl.exec_cmd("sleep 2 && blueman-applet")
	hl.exec_cmd("sleep 1 && pw-play $HOME/.config/hypr/startup.wav")
end)

-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

-- See https://wiki.hypr.land/configuring/core/environment-variables/

hl.env("GDK_WAYLAND_DISABLE", "ext_background_effect_manager_v1")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

---------------------
--- LOOK AND FEEL ---
---------------------

-- Refer to https://wiki.hypr.land/configuring/core/config-options/

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 1,
		resize_on_border = true,

		col = {
			active_border = { colors = { "rgba(bd5effff)", "rgba(ff6e5eff)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
	},

	decoration = {
		rounding = 4,
		inactive_opacity = 0.7,

		blur = {
			size = 12,
		},
	},

	dwindle = {
		preserve_split = true,
	},

	misc = {
		vrr = 2,
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},

	input = {
		touchpad = {
			tap_to_click = false,
			natural_scroll = true,
			disable_while_typing = true,
		},
	},
})

----------------
--- GESTURES ---
----------------

-- https://wiki.hypr.land/Configuring/Gestures/

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.gesture({
	fingers = 3,
	direction = "up",
	action = function()
		hl.plugin.hymission.open()
	end,
})
hl.gesture({
	fingers = 3,
	direction = "down",
	action = function()
		hl.plugin.hymission.close()
	end,
})

-------------------
--- KEYBINDINGS ---
-------------------

local mainMod = "SUPER"
local menu = "wofi --allow-images --normal-window --no-actions"
local drun = "pidof wofi && killall wofi || " .. menu .. ' --show drun --prompt "Choose a program"'

-- Cheatsheet registry (single source of truth for quickshell/cheatsheet)
local cheatsheet = {}
local cheatsheet_by_category = {}

local function add_cheatsheet(category, keys, desc)
	local cat = cheatsheet_by_category[category]
	if not cat then
		cat = { category = category, binds = {} }
		cheatsheet_by_category[category] = cat
		table.insert(cheatsheet, cat)
	end
	table.insert(cat.binds, { keys = keys, desc = desc })
end

local function bind(category, keys, dispatcher, desc, opts)
	local bind_opts
	if opts then
		bind_opts = {}
		for k, v in pairs(opts) do
			bind_opts[k] = v
		end
	end
	if desc then
		bind_opts = bind_opts or {}
		if not bind_opts.description and not bind_opts.desc then
			bind_opts.description = desc
		end
	end
	if category and desc then
		add_cheatsheet(category, keys, desc)
	end
	return hl.bind(keys, dispatcher, bind_opts)
end

-- See https://wiki.hypr.land/configuring/core/binds/ for more

-- Applications & Launchers
bind("Applications", mainMod .. " + Return", hl.dsp.exec_cmd("ghostty"), "Open terminal (Ghostty)")
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(drun), { description = "Application launcher" })
hl.bind("Menu", hl.dsp.exec_cmd(drun), { description = "Application launcher" })
add_cheatsheet("Applications", mainMod .. " + Space / Menu", "Application launcher")
bind(
	"Applications",
	mainMod .. " + R",
	hl.dsp.exec_cmd("pidof wofi && killall wofi || " .. menu .. " --show run"),
	"Run command"
)
bind(
	"Applications",
	mainMod .. " + F",
	hl.dsp.exec_cmd(
		'pidof wofi && killall wofi || xdg-open "$(fd | ' .. menu .. ' --show dmenu --prompt "File search")"'
	),
	"File search"
)
bind("Applications", mainMod .. " + E", hl.dsp.exec_cmd("thunar"), "File manager (Thunar)")
bind("Applications", mainMod .. " + H", hl.dsp.exec_cmd("firefox"), "Browser (Firefox)")

-- Screenshots & Recording
bind(
	"Screenshots & Recording",
	"Print",
	hl.dsp.exec_cmd(
		"mkdir -p $HOME/pictures/screenshots; grim $HOME/pictures/screenshots/$(date --iso-8601=seconds).png"
	),
	"Screenshot (full screen)"
)
bind(
	"Screenshots & Recording",
	"SHIFT + Print",
	hl.dsp.exec_cmd(
		'mkdir -p $HOME/pictures/screenshots; grim -g "$(slurp)" $HOME/pictures/screenshots/$(date --iso-8601=seconds).png'
	),
	"Screenshot (region)"
)
bind(
	"Screenshots & Recording",
	"CTRL + Print",
	hl.dsp.exec_cmd(
		"pidof wf-recorder && killall -s SIGINT wf-recorder || (mkdir -p $HOME/pictures/recordings && wf-recorder -f $HOME/pictures/recordings/$(date --iso-8601=seconds).mp4)"
	),
	"Record screen (toggle)"
)
bind(
	"Screenshots & Recording",
	"CTRL + SHIFT + Print",
	hl.dsp.exec_cmd(
		'pidof wf-recorder && killall -s SIGINT wf-recorder || (mkdir -p $HOME/pictures/recordings && wf-recorder -g "$(slurp)" -f $HOME/pictures/recordings/$(date --iso-8601=seconds).mp4)'
	),
	"Record region (toggle)"
)

-- Switch workspaces, move active window/workspace across workspaces and monitors with [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	local mon = i - 1 -- 1..10 maps to monitor 0..9

	-- Switch workspaces with mainMod + [0-9]
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Switch to workspace " .. i })
	-- Move active window to a workspace with mainMod + SHIFT + [0-9]
	hl.bind(
		mainMod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move window to workspace " .. i }
	)
	-- Move active window to monitor 0-9
	hl.bind(
		mainMod .. " + CTRL + " .. key,
		hl.dsp.window.move({ monitor = mon }),
		{ description = "Move window to monitor " .. mon }
	)
	-- Move current workspace to monitor 0-9
	hl.bind(
		mainMod .. " + CTRL + SHIFT + " .. key,
		hl.dsp.workspace.move({ monitor = mon }),
		{ description = "Move workspace to monitor " .. mon }
	)
end
add_cheatsheet("Workspaces & Monitors", mainMod .. " + 0-9", "Switch to workspace 1-10")
add_cheatsheet("Workspaces & Monitors", mainMod .. " + SHIFT + 0-9", "Move window to workspace 1-10")
add_cheatsheet("Workspaces & Monitors", mainMod .. " + CTRL + 0-9", "Move window to monitor 0-9")
add_cheatsheet("Workspaces & Monitors", mainMod .. " + CTRL + SHIFT + 0-9", "Move workspace to monitor 0-9")

hl.bind(
	mainMod .. " + SHIFT + up",
	hl.dsp.window.move({ workspace = "-1" }),
	{ description = "Move window to previous workspace" }
)
hl.bind(
	mainMod .. " + SHIFT + down",
	hl.dsp.window.move({ workspace = "+1" }),
	{ description = "Move window to next workspace" }
)
add_cheatsheet("Workspaces & Monitors", mainMod .. " + SHIFT + Up/Down", "Move window to prev/next workspace")

hl.bind(
	mainMod .. " + CTRL + up",
	hl.dsp.window.move({ monitor = "-1" }),
	{ description = "Move window to previous monitor" }
)
hl.bind(
	mainMod .. " + CTRL + down",
	hl.dsp.window.move({ monitor = "+1" }),
	{ description = "Move window to next monitor" }
)
add_cheatsheet("Workspaces & Monitors", mainMod .. " + CTRL + Up/Down", "Move window to prev/next monitor")

hl.bind(
	mainMod .. " + CTRL + SHIFT + up",
	hl.dsp.workspace.move({ monitor = "-1" }),
	{ description = "Move workspace to previous monitor" }
)
hl.bind(
	mainMod .. " + CTRL + SHIFT + down",
	hl.dsp.workspace.move({ monitor = "+1" }),
	{ description = "Move workspace to next monitor" }
)
add_cheatsheet("Workspaces & Monitors", mainMod .. " + CTRL + SHIFT + Up/Down", "Move workspace to prev/next monitor")

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
add_cheatsheet("Workspaces & Monitors", mainMod .. " + Scroll", "Scroll through workspaces")

bind("Workspaces & Monitors", mainMod .. " + W", displays.sync, "Redistribute workspaces across monitors")

-- Window Management
bind("Windows", mainMod .. " + C", hl.dsp.window.close(), "Close active window")
bind("Windows", mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }), "Toggle floating")
bind("Windows", mainMod .. " + P", hl.dsp.window.pseudo(), "Toggle pseudotile (dwindle)")
bind("Windows", mainMod .. " + J", hl.dsp.layout("togglesplit"), "Toggle split direction (dwindle)")

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }), { description = "Focus left" })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Focus right" })
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }), { description = "Focus up" })
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }), { description = "Focus down" })
add_cheatsheet("Windows", mainMod .. " + Arrows", "Move focus")

hl.bind("ALT + TAB", hl.dsp.exec_cmd("qs ipc -c alt-tab call alt-tab cycle"), { description = "Cycle windows forward" })
hl.bind(
	"ALT + SHIFT + TAB",
	hl.dsp.exec_cmd("qs ipc -c alt-tab call alt-tab cycleBack"),
	{ description = "Cycle windows backward" }
)
add_cheatsheet("Windows", "ALT + Tab / Shift+Tab", "Cycle windows")

bind(
	"Windows",
	"ALT + Space",
	hl.dsp.exec_cmd(
		'pidof wofi && killall wofi || hyprctl dispatch "hl.dsp.focus({ window = \\"address:$("$HOME"/.config/hypr/scripts/get_windows.py | '
			.. menu
			.. ' --show dmenu --cache-file=/dev/null --prompt "Choose a window" | grep -o \'0x.*$\')\\" })"'
	),
	"Search & switch window"
)

-- Move/resize windows with mainMod + LMB/RMB and dragging
bind("Windows", mainMod .. " + mouse:272", hl.dsp.window.drag(), "Move window (drag)", { mouse = true })
bind("Windows", mainMod .. " + mouse:273", hl.dsp.window.resize(), "Resize window (drag)", { mouse = true })

-- System & UI
bind(
	"System & UI",
	mainMod .. " + slash",
	hl.dsp.exec_cmd(
		"qs ipc -c cheatsheet call cheatsheet toggle || (qs -c cheatsheet -n -d && sleep 0.3 && qs ipc -c cheatsheet call cheatsheet toggle)"
	),
	"Toggle keybindings cheatsheet"
)
bind("System & UI", mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"), "Toggle notifications")
bind("System & UI", mainMod .. " + D", hl.dsp.exec_cmd("pkill -RTMIN+1 -f '^nwg-dock-hyprland'"), "Toggle dock")
bind(
	"System & UI",
	mainMod .. " + B",
	hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/blueconnect.sh"),
	"Bluetooth connect"
)
bind("System & UI", mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"), "Lock screen")
bind("System & UI", mainMod .. " + Q", hl.dsp.exec_cmd("$HOME/.config/waybar/scripts/power_menu.py"), "Power menu")
bind("System & UI", mainMod .. " + M", hl.dsp.exit(), "Exit Hyprland")

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume raise"),
	{ locked = true, repeating = true, description = "Volume up" }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume lower"),
	{ locked = true, repeating = true, description = "Volume down" }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),
	{ locked = true, repeating = true, description = "Toggle audio mute" }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),
	{ locked = true, repeating = true, description = "Toggle mic mute" }
)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("swayosd-client --brightness raise"),
	{ locked = true, repeating = true, description = "Brightness up" }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("swayosd-client --brightness lower"),
	{ locked = true, repeating = true, description = "Brightness down" }
)

-- Requires playerctl
hl.bind(
	"XF86AudioNext",
	hl.dsp.exec_cmd("swayosd-client --playerctl next"),
	{ locked = true, description = "Next track" }
)
hl.bind(
	"XF86AudioPause",
	hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"),
	{ locked = true, description = "Play / Pause" }
)
hl.bind(
	"XF86AudioPlay",
	hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"),
	{ locked = true, description = "Play / Pause" }
)
hl.bind(
	"XF86AudioPrev",
	hl.dsp.exec_cmd("swayosd-client --playerctl prev"),
	{ locked = true, description = "Previous track" }
)

-- Export cheatsheet JSON for Quickshell overlay
local function json_escape(str)
	return (tostring(str):gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\t", "\\t"))
end

local function write_cheatsheet_json()
	local lines = { "[" }
	for i, cat in ipairs(cheatsheet) do
		table.insert(lines, '  {"category": "' .. json_escape(cat.category) .. '", "binds": [')
		for j, entry in ipairs(cat.binds) do
			local comma = (j < #cat.binds) and "," or ""
			table.insert(
				lines,
				'    {"keys": "'
					.. json_escape(entry.keys)
					.. '", "desc": "'
					.. json_escape(entry.desc)
					.. '"}'
					.. comma
			)
		end
		local cat_comma = (i < #cheatsheet) and "," or ""
		table.insert(lines, "  ]}" .. cat_comma)
	end
	table.insert(lines, "]")

	local dir = os.getenv("XDG_RUNTIME_DIR") or "/tmp"
	local path = dir .. "/hypr-cheatsheet.json"
	local tmp = path .. ".tmp"
	local f = io.open(tmp, "w")
	if f then
		f:write(table.concat(lines, "\n") .. "\n")
		f:close()
		os.rename(tmp, path)
	end
end

write_cheatsheet_json()

--------------------
--- WINDOW RULES ---
--------------------

-- See https://wiki.hypr.land/configuring/core/rules/

hl.window_rule({
	-- Ignore maximize requests from all apps.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.layer_rule({
	name = "dock-animation",
	match = { namespace = "nwg-dock" },
	animation = "slide bottom",
})

-----------------------
--- WORKSPACE ICONS ---
-----------------------

local workspace_icons = {
	["firefox"] = "󰈹 ",
	["google-chrome"] = " ",
	["glide-glide"] = " ",
	["kitty"] = " ",
	["com.mitchellh.ghostty"] = " ",
	["dev.warp.Warp"] = " ",
	["org.kde.dolphin"] = " ",
	["thunar"] = " ",
	["xdg-desktop-portal-gtk"] = " ",
	["zenity"] = " ",
	["spotify"] = " ",
	["vlc"] = "󰕼 ",
	["virt-viewer"] = "󰍹 ",
	["remote-viewer"] = "󰍹 ",
	["com.onepassword.OnePassword"] = "󰯅 ",
	["qdbusviewer"] = " ",
	["mpv"] = " ",
	["qvidcap"] = " ",
	["com.obsproject.Studio"] = " ",
	["Audacity"] = " ",
	["blueman-manager"] = " ",
	["kbd-layout-viewer"] = " ",
	["neovide"] = " ",
	["io.missioncenter.MissionCenter"] = " ",
	["Slack"] = " ",
	["Docker Desktop"] = " ",
	["com.system76.keyboardconfigurator"] = " ",
}

-- Custom naming for each workspace based on the last active window:
-- - If the last active window (in the workspace) has an entry in `workspace_icons`, use that icon.
-- - If any window in the workspace has an entry in `workspace_icons`, use that icon.
-- - If the workspace has at least one window, but none in `workspace_icons`, use a generic  .
-- - Otherwise, name the workspace its ID.
-- Zero-width spaces (U+200B) are appended per workspace ID so icon names stay unique across workspaces.
local zwsp = "\226\128\139"

local ignored_workspace_classes = {
	["wofi"] = true,
	["org.quickshell"] = true,
	["quickshell"] = true,
}

local function is_ignored_window(win)
	return not win or not win.mapped or ignored_workspace_classes[win.class] or win.title == "quickshell-alt-tab"
end

local function update_workspace_name(ws)
	if not ws or ws.special or not ws.id then
		return
	end

	local icon
	local last = ws.last_window
	if not is_ignored_window(last) and workspace_icons[last.class] then
		icon = workspace_icons[last.class]
	else
		local has_windows = false
		for _, win in ipairs(ws:get_windows()) do
			if not is_ignored_window(win) then
				has_windows = true
				if workspace_icons[win.class] then
					icon = workspace_icons[win.class]
					break
				end
			end
		end
		if not icon and has_windows then
			icon = " "
		end
	end

	local name = icon and (icon .. zwsp:rep(math.max(0, ws.id))) or tostring(ws.id)

	if ws.name ~= name then
		hl.dispatch(hl.dsp.workspace.rename({ workspace = ws.id, name = name }))
	end
end

local function update_all_workspaces()
	for _, ws in ipairs(hl.get_workspaces()) do
		update_workspace_name(ws)
	end
end

for _, event in ipairs({ "window.active", "window.open", "window.title", "window.class" }) do
	hl.on(event, function(win)
		if win and win.workspace then
			update_workspace_name(win.workspace)
		else
			update_all_workspaces()
		end
	end)
end

for _, event in ipairs({
	"window.close",
	"window.destroy",
	"window.move_to_workspace",
	"workspace.created",
	"hyprland.start",
	"config.reloaded",
}) do
	hl.on(event, function()
		update_all_workspaces()
	end)
end

update_all_workspaces()

-----------------------
--- DOCK VISIBILITY ---
-----------------------

-- Show nwg-dock-hyprland when the active workspace has no non-ignored windows,
-- and hide it otherwise.
local dock_visible = nil
local dock_workspace = nil

local function is_dock_ready()
	return #hl.get_layers({ namespace = "hotspot" }) > 0 or #hl.get_layers({ namespace = "nwg-dock" }) > 0
end

local function workspace_has_windows(ws)
	if not ws then
		return false
	end
	for _, win in ipairs(ws:get_windows()) do
		if not is_ignored_window(win) then
			return true
		end
	end
	return false
end

local function update_dock_visibility()
	if not is_dock_ready() then
		return
	end

	local ws = hl.get_active_workspace()
	local special_ws = hl.get_active_special_workspace()
	local should_show = not workspace_has_windows(ws) and not workspace_has_windows(special_ws)
	local ws_id = ws and ws.id or nil

	if should_show then
		if not dock_visible or ws_id ~= dock_workspace then
			dock_visible = true
			dock_workspace = ws_id
			hl.exec_cmd("pkill -RTMIN+2 -f '^nwg-dock-hyprland'")
		end
	elseif dock_visible ~= false then
		dock_visible = false
		dock_workspace = ws_id
		hl.exec_cmd("pkill -RTMIN+3 -f '^nwg-dock-hyprland'")
	end
end

hl.on("layer.opened", function(layer)
	if layer and (layer.namespace == "hotspot" or layer.namespace == "nwg-dock") and dock_visible == nil then
		update_dock_visibility()
	end
end)

hl.on("layer.closed", function(layer)
	if layer and (layer.namespace == "hotspot" or layer.namespace == "nwg-dock") and not is_dock_ready() then
		dock_visible = nil
		dock_workspace = nil
	end
end)

for _, event in ipairs({
	"workspace.active",
	"workspace.special_active",
	"monitor.focused",
	"window.open",
	"window.close",
	"window.destroy",
	"window.move_to_workspace",
	"config.reloaded",
}) do
	hl.on(event, update_dock_visibility)
end

update_dock_visibility()
