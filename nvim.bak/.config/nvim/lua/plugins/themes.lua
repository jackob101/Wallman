return {
  {
    "olivercederborg/poimandres.nvim",
    priority = 1000,
    opts = {}
  },
  -- {
  --   "nyoom-engineering/oxocarbon.nvim",
  --   priority = 1000,
  --   opts = {}
  -- },
  -- {
  --   "JoosepAlviste/palenightfall.nvim",
  --   priority = 1000,
  --   opts = {}
  -- },
  {
    "Shatur/neovim-ayu",
    priority = 1000,
    config = function()
      require("ayu").setup({})
    end
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        overrides = function(colors)
          return {
            DiagnosticUnderlineError = { undercurl = false, underline = true },
            DiagnosticUnderlineWarn = { undercurl = false, underline = true },
            DiagnosticUnderlineInf = { undercurl = false, underline = true },
            DiagnosticUnderlineHint = { undercurl = false, underline = true },
            IndentBlanklineSpaceChar = { fg = "#2A2A37" },
            IndentBlanklineChar = { fg = "#2A2A37" },
            NavicText = { bg = "#2a2a37" },
            NavicSeparator = { bg = "#2a2a37" },
            NavicIconsFile = { bg = "#2a2a37" },
            NavicIconsModule = { bg = "#2a2a37" },
            NavicIconsNamespace = { bg = "#2a2a37" },
            NavicIconsPackage = { bg = "#2a2a37" },
            NavicIconsClass = { bg = "#2a2a37" },
            NavicIconsMethod = { bg = "#2a2a37" },
            NavicIconsProperty = { bg = "#2a2a37" },
            NavicIconsField = { bg = "#2a2a37" },
            NavicIconsConstructor = { bg = "#2a2a37" },
            NavicIconsEnum = { bg = "#2a2a37" },
            NavicIconsInterface = { bg = "#2a2a37" },
            NavicIconsFunction = { bg = "#2a2a37" },
            NavicIconsVariable = { bg = "#2a2a37" },
            NavicIconsConstant = { bg = "#2a2a37" },
            NavicIconsString = { bg = "#2a2a37" },
            NavicIconsNumber = { bg = "#2a2a37" },
            NavicIconsBoolean = { bg = "#2a2a37" },
            NavicIconsArray = { bg = "#2a2a37" },
            NavicIconsObject = { bg = "#2a2a37" },
            NavicIconsKey = { bg = "#2a2a37" },
            NavicIconsNull = { bg = "#2a2a37" },
            NavicIconsEnumMember = { bg = "#2a2a37" },
            NavicIconsStruct = { bg = "#2a2a37" },
            NavicIconsEvent = { bg = "#2a2a37" },
            NavicIconsOperator = { bg = "#2a2a37" },
            NavicIconsTypeParameter = { bg = "#2a2a37" },
          }
        end,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none"
              }
            }
          }
        }
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "storm" },
  },
  {
    "sainnhe/everforest",
    version = false,
    priority = 1000,
    lazy = false,
    opts = {
      background = "hard"
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  }
}
