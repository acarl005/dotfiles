----------------
--- MONITORS ---
----------------

-- See https://wiki.hypr.land/configuring/core/monitors/

-- ASUS Zephyrus G16 display
hl.monitor({
	output = "desc:Samsung Display Corp. ATNA60DL01-0",
	mode = "2560x1600@240",
	position = "0x0",
	scale = 1.6,
	vrr = 1,
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

-----------------
--- AUTOSTART ---
-----------------

-- See https://wiki.hypr.land/configuring/core/autostart/

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("waybar")
	hl.exec_cmd("fcitx5")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("swaync")
	hl.exec_cmd("qs -c alt-tab")
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

---------------------
--- LOOK AND FEEL ---
---------------------

-- Refer to https://wiki.hypr.land/configuring/core/config-options/

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 1,

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
	action = "float",
})

-------------------
--- KEYBINDINGS ---
-------------------

local mainMod = "SUPER"
local menu = "wofi --allow-images --normal-window --no-actions"
local drun = "pidof wofi && killall wofi || " .. menu .. ' --show drun --prompt "Choose a program"'

-- See https://wiki.hypr.land/configuring/core/binds/ for more
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(drun))
hl.bind("Menu", hl.dsp.exec_cmd(drun))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(
	mainMod .. " + F",
	hl.dsp.exec_cmd(
		'pidof wofi && killall wofi || xdg-open "$(fd | ' .. menu .. ' --show dmenu --prompt "File search")"'
	)
)
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("pidof wofi && killall wofi || " .. menu .. " --show run"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/move-workspaces.sh"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/blueconnect.sh"))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("$HOME/.config/waybar/scripts/power_menu.py"))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("firefox"))

hl.bind(
	"Print",
	hl.dsp.exec_cmd(
		"mkdir -p $HOME/pictures/screenshots; grim $HOME/pictures/screenshots/$(date --iso-8601=seconds).png"
	)
)
hl.bind(
	"SHIFT + Print",
	hl.dsp.exec_cmd(
		'mkdir -p $HOME/pictures/screenshots; grim -g "$(slurp)" $HOME/pictures/screenshots/$(date --iso-8601=seconds).png'
	)
)
hl.bind(
	"CTRL + Print",
	hl.dsp.exec_cmd(
		"pidof wf-recorder && killall -s SIGINT wf-recorder || (mkdir -p $HOME/pictures/recordings && wf-recorder -f $HOME/pictures/recordings/$(date --iso-8601=seconds).mp4)"
	)
)
hl.bind(
	"CTRL + SHIFT + Print",
	hl.dsp.exec_cmd(
		'pidof wf-recorder && killall -s SIGINT wf-recorder || (mkdir -p $HOME/pictures/recordings && wf-recorder -g "$(slurp)" -f $HOME/pictures/recordings/$(date --iso-8601=seconds).mp4)'
	)
)

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces, move active window/workspace across workspaces and monitors with [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	local mon = i - 1 -- 1..10 maps to monitor 0..9

	-- Switch workspaces with mainMod + [0-9]
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	-- Move active window to a workspace with mainMod + SHIFT + [0-9]
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
	-- Move active window to monitor 0-9
	hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ monitor = mon }))
	-- Move current workspace to monitor 0-9
	hl.bind(mainMod .. " + CTRL + SHIFT + " .. key, hl.dsp.workspace.move({ monitor = mon }))
end

hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ workspace = "+1" }))

hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ monitor = "-1" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ monitor = "+1" }))

hl.bind(mainMod .. " + CTRL + SHIFT + up", hl.dsp.workspace.move({ monitor = "-1" }))
hl.bind(mainMod .. " + CTRL + SHIFT + down", hl.dsp.workspace.move({ monitor = "+1" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("ALT + TAB", hl.dsp.exec_cmd("qs ipc -c alt-tab call alt-tab cycle"))
hl.bind("ALT + SHIFT + TAB", hl.dsp.exec_cmd("qs ipc -c alt-tab call alt-tab cycleBack"))

hl.bind(
	"ALT + Space",
	hl.dsp.exec_cmd(
		'pidof wofi && killall wofi || hyprctl dispatch "hl.dsp.focus({ window = \\"address:$("$HOME"/.config/hypr/scripts/get_windows.py | '
			.. menu
			.. ' --show dmenu --cache-file=/dev/null --prompt "Choose a window" | grep -o \'0x.*$\')\\" })"'
	)
)

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
