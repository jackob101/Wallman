local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local icons = require("icons")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("modules.exit-screen.clickable-container")
local naughty = require("naughty")

local greeter_message = wibox.widget {
  markup = 'Choose wisely!',
  font = 'Inter UltraLight 48',
  align = 'center',
  valign = 'center',
  widget = wibox.widget.textbox
}

local profile_name = wibox.widget {
  markup = 'Jackob',
  font = 'Inter Bold 12',
  align = 'center',
  valign = 'center',
  widget = wibox.widget.textbox
}

local profile_imagebox = wibox.widget {
  image = icons.default,
  resize = true,
  forced_height = dpi(140),
  clip_shape = gears.shape.circle,
  widget = wibox.widget.imagebox
}



local build_power_button = function(name, icon, callback)
  local power_button_label=wibox.widget {
    text = name,
    font = "Ubuntu 14",
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  }

  local power_button = wibox.widget{
    {
      {
        {
          {
            image = icon,
            widget = wibox.widget.imagebox
          },
          margins = dpi(16),
          widget = wibox.container.margin
        },
        bg = beautiful.groups_bg,
        widget = wibox.container.background
      },
      shape = gears.shape.rounded_rect,
      forced_height = dpi(120),
      forced_width = dpi(120),
      widget = clickable_container,
    },
    left = dpi(24),
    right = dpi(24),
    widget = wibox.container.margin
  }

  local exit_screen_item = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(5),
    power_button,
    power_button_label
  }

  exit_screen_item:connect_signal(
    'button::release',
    function()
      callback()
    end
  )
  return exit_screen_item

end

local suspend_command = function()
  awesome.emit_signal('module::exit_screen:hide')
  awful.spawn.with_shell('systemctl suspend')
end

local logout_command = function()
  awesome.quit()
end

local lock_command = function()
  awesome.emit_signal('module::exit_screen:hide')
  naughty.notification{title = "Warning", text= "Not yet implemented"}
end

local poweroff_command = function()
  awful.spawn.with_shell('poweroff')
  awesome.emit_signal('module::exit_screen:hide')
end

local reboot_command = function()
  awful.spawn.with_shell('reboot')
  awesome.emit_signal('module::exit_screen:hide')
end

local poweroff = build_power_button('Shutdown(p)', icons.power, poweroff_command)
local reboot = build_power_button('Restart(r)', icons.restart, reboot_command)
local suspend = build_power_button('Sleep(s)', icons.sleep, suspend_command)
local logout = build_power_button('Logout(e)', icons.logout, logout_command)
local lock = build_power_button('Lock', icons.lock, lock_command)


local create_exit_screen = function(s)
  s.exit_screen = wibox
  {
    screen = s,
    type = 'splash',
    visible = false,
    ontop = true,
    bg = beautiful.bg_normal .. "CC",
    fg = beautiful.fg_normal,
    height = s.geometry.height,
    width = s.geometry.width,
    x = s.geometry.x,
    y = s.geometry.y
  }

  s.exit_screen:buttons(
    gears.table.join(
      awful.button(
        {},
        2,
        function()
          awesome.emit_signal('module::exit_screen:hide')
        end
      ),
      awful.button(
        {},
        3,
        function()
          awesome.emit_signal('module::exit_screen:hide')
        end
      )
    )
  )

  s.exit_screen : setup {
    layout = wibox.layout.align.vertical,
    expand = 'none',
    nil,
    {
      layout = wibox.layout.align.vertical,
      {
        nil,
        {
          layout = wibox.layout.fixed.vertical,
          spacing = dpi(5),
          {
            layout = wibox.layout.align.vertical,
            expand = 'none',
            nil,
            {
              layout = wibox.layout.align.horizontal,
              expand = 'none',
              nil,
              profile_imagebox,
              nil
            },
            nil
          },
          profile_name
        },
        nil,
        expand = 'none',
        layout = wibox.layout.align.horizontal
      },
      {
        layout = wibox.layout.align.horizontal,
        expand = 'none',
        nil,
        {
          widget = wibox.container.margin,
          margins = dpi(20),
          greeter_message
        },
        nil
      },
      {
        layout = wibox.layout.align.horizontal,
        expand = 'none',
        nil,
        {
          {
            {
              poweroff,
              reboot,
              suspend,
              logout,
              lock,
              layout = wibox.layout.fixed.horizontal
            },
            spacing = dpi(30),
            layout = wibox.layout.fixed.vertical
          },
          widget = wibox.container.margin,
          margins = dpi(15)
        },
        nil
      }
    },
    nil}
end

screen.connect_signal(
  'request::desktop_decoration',
  function(s)
    create_exit_screen(s)
  end
)

screen.connect_signal(
  'removed',
  function(s)
    create_exit_screen(s)
  end
)

local exit_screen_grabber = awful.keygrabber {
  auto_start = true,
  stop_event = 'release',
  keypressed_callback = function( _, _, key, _)
    if key == 's' then
      suspend_command()

    elseif key == 'e' then
      logout_command()

    elseif key == 'l' then
      lock_command()

    elseif key == 'p' then
      poweroff_command()

    elseif key == 'r' then
      reboot_command()

    elseif key == 'Escape' or key == 'q' or key == 'x' then
      awesome.emit_signal('module::exit_screen:hide')
    end
  end
}

awesome.connect_signal(
  'module::exit_screen:show',
  function()
    for s in screen do
      s.exit_screen.visible = false
    end
    awful.screen.focused().exit_screen.visible = true
    exit_screen_grabber:start()
  end
)

awesome.connect_signal(
  'module::exit_screen:hide',
  function()
    exit_screen_grabber:stop()
    for s in screen do
      s.exit_screen.visible = false
    end
  end
)
