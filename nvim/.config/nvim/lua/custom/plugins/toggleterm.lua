return {
  tag = "v2.*",
  config = function()
    require("toggleterm").setup {}
    require "base46.term"
    local Terminal = require("toggleterm.terminal").Terminal
    --
    local lazygit = Terminal:new {
      cmd = "lazygit",
      hidden = true,
      direction = "float",
    }

    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end
  end,
}
