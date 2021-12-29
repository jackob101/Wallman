local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local sound_sinks = require("widgets.sound-sinks")

local text_widget = sound_sinks.create_label("Test")

local entries = {}


local example_widget = wibox.widget{

  bg = "#FFFFFF",
  forced_width = 150,
  forced_height = 100,
  widget = wibox.container.background,

}

local create_settings_widget = function(s)


  s.settings_widget = wibox{
    screen = s,
    type = "splash",
    visible = false,
    ontop = true,
    bg = beautiful.background,
    fg = beautiful.fg_normal,
    height = s.geometry.height,
    width = s.geometry.width,
    x = s.geometry.x,
    y = s.geometry.y
  }

  s.settings_widget:buttons(
    gears.table.join(
      awful.button(
        {},
        2,
        function()
          awesome.emit_signal('module::settings_widget:hide')
        end
      ),
      awful.button(
        {},
        3,
        function()
          awesome.emit_signal('module::settings_widget:hide')
        end
      )
    )
  )

  example_widget.point = function (geo, args)
    local x = args.parent.width - geo.width;
    local y = (args.parent.height / 2 ) - (geo.height/2);

    gears.debug.print_error("This is args param")
    gears.debug.dump(args)
    gears.debug.dump(x)
    gears.debug.dump(y)
    gears.debug.print_error("This is geo param")
    gears.debug.dump(geo)

    return {x = x, y = y}
  end

  gears.debug.dump(sound_sinks.volume_settings)

  s.settings_widget:setup {
    sound_sinks.generate_widget(),
    layout = wibox.layout.manual
  }


end

screen.connect_signal(
  'request::desktop_decoration',
  function(s)
    create_settings_widget(s)
  end
)

screen.connect_signal(
  'removed',
  function(s)
    create_settings_widget(s)
  end
)


local settings_widget_grabber = awful.keygrabber{
  auto_start = true,
  stop_event = 'release',
  keypressed_callback = function(self, mod, key, command)
    if key == 'Escape' or key == 'q' or key == 'x' then
      awesome.emit_signal('module::settings_widget:hide')
    end
  end
}

awesome.connect_signal(
  'module::settings_widget:show',
  function()

    local sinks = sound_sinks.get_input_sinks(example_widget)

    for s in screen do

      s.settings_widget.visible=false;
    end

    awful.screen.focused().settings_widget.visible = true;
    settings_widget_grabber:start()
  end
)

awesome.connect_signal(
  'module::settings_widget:hide',
  function ()
	settings_widget_grabber:stop()
    for s in screen do
      s.settings_widget.visible = false
    end
  end
)
