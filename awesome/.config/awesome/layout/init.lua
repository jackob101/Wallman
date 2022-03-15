local central_panel = require("layout.central_panel")

screen.connect_signal(
  "request::desktop_decoration",
  function (s)
    s.central_panel = central_panel(s)
  end
)
