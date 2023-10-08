return {
  'ThePrimeagen/harpoon',
  opts = { save_on_toggle = true },
  keys = {
    { '<leader>ma', "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = 'Add harpoon mark' },
    { '<leader>mL', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = 'Toggle quick menu' },
    { '<leader>ml', '<cmd>Telescope harpoon marks<cr>', desc = 'Telescope harpoon marks' },
    { '<leader>mC', '<cmd>lua require(harpoon.mark).clear_all()<cr>', desc = 'Clear all marks' },
  },
}
