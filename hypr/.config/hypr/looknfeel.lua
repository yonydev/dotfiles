-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
  decoration = {
    -- Use round window corners.
    rounding = 12,

    -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
    dim_inactive = true,
    dim_strength = 0.25,
  },
})

-- Gravity: windows drop in from above and bounce, fall away on close,
-- and workspaces ride vertically like an elevator
hl.curve("landing", { type = "bezier", points = { { 0.22, 1.15 }, { 0.45, 1 } } })
hl.curve("floatOut", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })

hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "landing", style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2.8, bezier = "landing", style = "slidevert" })
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "landing" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.2, bezier = "landing", style = "slide top" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.2, bezier = "easeInOutCubic", style = "slide bottom" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "landing", style = "slide top" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.4, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.2, bezier = "almostLinear" })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })
