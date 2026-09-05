-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1.25

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Dell U2723QE (docked, lid closed); matched by EDID description so the rule
-- follows the monitor across ports and machines, and "preferred" lets each
-- connection negotiate its best mode (30Hz over this HDMI port, 60Hz over DP).
-- The laptop panel intentionally has no explicit rule so the scale menu can
-- manage it via the catch-all above.
hl.monitor({ output = "desc:Dell Inc. DELL U2723QE 2BFH1P3", mode = "preferred", position = "0x0", scale = 2 })

-- Pin workspaces: 1-5 on the Dell, 6-10 on the laptop panel. When the Dell
-- disconnects, Hyprland folds 1-5 onto the laptop and moves them back on reconnect.
for ws = 1, 5 do
  hl.workspace_rule({ workspace = tostring(ws), monitor = "desc:Dell Inc. DELL U2723QE 2BFH1P3", default = (ws == 1) })
end
for ws = 6, 10 do
  hl.workspace_rule({ workspace = tostring(ws), monitor = "eDP-1", default = (ws == 6) })
end

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
