return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = { --[[ things you want to change go here]]
      -- open_mapping = [[<c-/>]],
    },
    keys = {
      { '<C-/>', '<cmd>ToggleTerm direction=float<cr>', desc = 'Floating terminal' },
      {
        '<C-/>',
        '<cmd>ToggleTerm direction=float<cr>',
        mode = 't',
        desc = 'Floating terminal',
      },
      { '<M-1>', '<cmd>ToggleTerm direction=horizontal size=30<cr>', desc = 'Toggle term' },
    },
  },
}
