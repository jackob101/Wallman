return {
  {
    'rose-pine/neovim',
    enabled = false,
    priority = 1000,
    config = function()
      require('lazy').setup {
        { 'rose-pine/neovim', name = 'rose-pine' },
      }
      vim.cmd 'colorscheme rose-pine'
    end,
  },
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    -- enabled = false,
    priority = 1000,
    config = function()
      require('onedark').setup {
        colors = {
          bg0 = '#282c33',
        },
        diagnostics = {
          darker = true,     -- darker colors for diagnostic
          undercurl = false, -- use undercurl instead of underline for diagnostics
          -- background = true, -- use background color for virtual text
        },
      }
      vim.cmd.colorscheme 'onedark'
    end,
  },
}
