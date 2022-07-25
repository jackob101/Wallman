---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()
local dpi = xresources.apply_dpi
local gears = require("gears")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

awesome.set_preferred_icon_size(128)

local theme = {}

--  Theme font
theme.font = "inter medium 9"


-- General settings
theme.color8 = xrdb.color8
theme.color9 = xrdb.color9
theme.color10 = xrdb.color10
theme.color11 = xrdb.color11
theme.color12 = xrdb.color12
theme.color13 = xrdb.color13
theme.color14 = xrdb.color14
theme.color15 = xrdb.color15

theme.accent1 = xrdb.color10
theme.accent2 = xrdb.color11
theme.accent3 = xrdb.color12
theme.accent4 = xrdb.color13
theme.accent5 = xrdb.color14
theme.accent6 = xrdb.color15

theme.useless_gap = dpi(5)
theme.gap_single_client = false

theme.bg_normal = xrdb.background or "#2E3440"
theme.bg_overlay = xrdb.color1
theme.bg_transparent = theme.bg_normal .. "AA"
theme.bg_focus = xrdb.color2 or "#535d6c"
theme.bg_overlay_transparent = theme.bg_overlay .. "EE"
theme.bg_hover = xrdb.color3
theme.bg_hover_transparent = theme.bg_hover .. "AA"
theme.bg_urgent = xrdb.color9 or "#D08770"
theme.bg_minimize = xrdb.color8 or "#3B4252"

theme.fg_normal = xrdb.foreground or "#8DEE9"
theme.fg_focus = xrdb.foreground or "#ECEFF4"
theme.fg_urgent = xrdb.color9 or "#D08770"
theme.fg_minimize = xrdb.foreground or "#D8DEE9"


-- Status bar
theme.bar_height = dpi(32)
theme.bar_opacity = "FF"
theme.bar_icon_text_spacing = dpi(5)
theme.bar_icon_margin = dpi(2)

theme.groups_bg = xrdb.color2 .. "77"

-- Generate taglist squares:
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(dpi(0), theme.fg_focus)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(dpi(0), theme.fg_normal)
theme.taglist_fg_focus = theme.fg_normal
theme.taglist_fg_urgent = theme.fg_normal
theme.taglist_bg_focus = xrdb.color10
theme.taglist_bg_urgent = xrdb.color9
theme.taglist_bg_occupied = theme.bg_overlay_transparent
-- theme.taglist_bg_occupied = xrdb.color12
-- theme.taglist_fg_occupied = xrdb.background
theme.taglist_font = "inter bold 12"
theme.taglist_only_icons = true

----    Tag

theme.tag = {
    label_margins = dpi(5),
    label_forced_width = dpi(25),

    tasks_margins = dpi(6),
    tasks_spacing = dpi(7),
    tasks_right_margin = dpi(9),

    underline_height = dpi(3),
    hover_color = "#FFFFFF15"
}

theme.titlebar = {
    control_button_width = dpi(40),
    control_button_margins = dpi(6),
    control_button_hover_color = "#FFFFFF22",

    floating_symbol = "✈",
    floating_font = "inter medium 11",

    icon_padding = dpi(3),

    left_components_spacing = dpi(5),

    close_color = theme.color9,
    maximize_color = theme.color10,
    minimize_color = theme.color11,
}

theme.task = {
    task_spacing = dpi(5),

    top_margin = dpi(4),
    bottom_margin = dpi(4),
    left_margin = dpi(8),
    right_margin = dpi(8),
}

theme.dashboard = {

}

theme.tiling_status = {
    bg = theme.color10,
    left_margin = dpi(8),
    right_margin = dpi(8),
    fg = theme.bg_normal,
    font = "inter medium 10",
}

theme.notification = {
    bg = theme.bg_overlay .. "99",
    width = dpi(320),
    box_padding = dpi(10),
    border_normal = theme.bg_hover,
    border_urgent = theme.bg_urgent,
    message_height = dpi(40),
}


-- Bling configs
theme.flash_focus_start_opacity = 0.7
theme.flash_focus_step = 0.02

theme.transparent = "#FFFFFF00"

theme.border_width = dpi(1)
theme.border_normal = xrdb.color6 or "#000000"
theme.border_focus = xrdb.color5 or "#535d6c"
theme.border_marked = xrdb.color10 or "#91231c"

theme.hotkeys_font = "Ubuntu 10"
theme.hotkeys_description_font = "Ubuntu 10"
theme.hotkeys_border_color = xrdb.color5
theme.hotkeys_modifiers_fg = xrdb.color11
theme.hotkeys_label_bg = xrdb.color10

theme.tooltip_bg = xrdb.color1
theme.tooltip_margins = dpi(10)
theme.tooltip_font = "Inter 10"
theme.tooltip_border_width = dpi(1)
theme.tooltip_border_color = theme.border_normal

theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_bg_normal = theme.transparent
theme.tasklist_disable_task_name = false
theme.tasklist_plain_task_name = true

theme.notification_icon_size = dpi(50)
--theme.notification_max_width = dpi(400)
-- theme.notification_height = 150
theme.notification_spacing = dpi(20)
--theme.notification_box_margin = 10
theme.notification_title_font = "inter medium 11"

theme.systray_icon_spacing = 5

theme.notification_center_opacity = "FF"
theme.notification_center_width = dpi(350)
theme.notification_center_border_width = dpi(5)

theme.dashboard_border_width = dpi(2)
theme.dashboard_border_color = theme.bg_focus
theme.dashboard_margin = dpi(20)

theme.central_panel_max_width = dpi(400)
theme.central_panel_max_height = dpi(700)

theme.menu_icon_size = dpi(16)
theme.menu_icon_color = theme.fg_normal
-- Some default values

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_bg = theme.bg_normal
theme.titlebar_bg_focus = theme.bg_normal
theme.titlebar_controls_spacing = dpi(25)
theme.titlebar_left_edge_padding = dpi(8)
theme.titlebar_right_edge_padding = dpi(15)
theme.titlebar_icon_padding = dpi(3)
theme.titlebar_top_edge_padding = dpi(3)
theme.titlebar_bottom_edge_padding = dpi(3)
theme.titlebar_controls_hover_overlay = "#FFFFFF22"
-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "default/titlebar/maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "gnome"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
