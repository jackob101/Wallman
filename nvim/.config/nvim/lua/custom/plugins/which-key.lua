return {
  disable = false,
  config = function()
    local wk = require "which-key"
    wk.register({
      l = {
        name = "LSP Actions",
      },
      g = {
        name = "Git",
      },
    }, { prefix = "<leader>" }) --insert any whichkey opts here
  end,
}
