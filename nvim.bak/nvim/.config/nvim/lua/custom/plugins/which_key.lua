return {
  {
    'folke/which-key.nvim',
    config = function()
      local wk = require 'which-key'
      wk.setup()

      wk.register({
        f = { name = 'Find' },
        g = { name = 'git' },
        t = { name = 'toggle' },
      }, { prefix = '<leader>' })

      wk.register {
        ['<C-s>'] = { '<cmd>w<cr>', 'Save buffer' },
        ['<A-s>'] = { '<cmd>e #<cr>', 'Switch with previous buffer' },
        ['<A-l>'] = { '<C-w>l', 'Right split' },
        ['<A-h>'] = { '<C-w>h', 'Left split' },
        ['<A-j>'] = { '<C-w>j', 'Bottom split' },
        ['<A-k>'] = { '<C-w>k', 'Top split' },
      }
    end,
  },
}
