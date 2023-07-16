return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'ThePrimeagen/harpoon' },
    keys = {
      { '<leader>ff', '<cmd>Telescope find_files<cr>',                desc = 'Find files' },
      { '<leader>fk', '<cmd>Telescope keymaps<cr>',                   desc = 'Show keymaps' },
      { '<leader>fg', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'Current buffer fuzzy find' },
      { '<leader>fG', '<cmd>Telescope live_grep<cr>',                 desc = 'Live grep' },
    },
    config = function()
      require('telescope').setup()
      require('telescope').load_extension 'harpoon'
    end,
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
}
