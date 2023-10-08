return {
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        enable = false,
        priority = 1000,
        config = function()
            require('catppuccin').setup {
                transparent_background = false,
                integrations = {
                    telescope = {
                        enabled = true,
                    },
                },
                custom_highlights = function(colors)
                    return {
                        FidgetTitle = { link = 'NormalFloat' },
                        FidgetTask = { link = 'NormalFloat' },
                        -- IndentBlanklineChar = { fg = colors.crust },
                        -- IndentBlanklineSpaceChar = { fg = colors.crust },
                        -- IndentBlanklineSpaceCharBlankline = { fg = colors.crust },
                    }
                end,
            }
            vim.cmd 'colorscheme catppuccin-frappe'
        end,
    },
    -- {
    --     'Everblush/nvim',
    --     name = 'everblush',
    --     priority = 1000,
    --     config = function()
    --         require('everblush').setup()
    --         vim.cmd 'colorscheme everblush'
    --     end,
    -- },
    -- {
    --     'EdenEast/nightfox.nvim',
    --     priority = 1000,
    --     config = function()
    --         require('nightfox').setup()
    --         vim.cmd 'colorscheme nightfox'
    --     end,
    -- },
    -- {
    --     'rebelot/kanagawa.nvim',
    --     config = function()
    --         require('kanagawa').setup {}
    --         -- vim.cmd 'colorscheme kanagawa-wave'
    --     end,
    -- },
    -- {
    --     'neanias/everforest-nvim',
    --     enable = false,
    --     config = function()
    --         require('everforest').setup {}
    --         -- vim.cmd 'colorscheme everforest'
    --     end,
    -- },
    -- {
    --     'rose-pine/neovim',
    --     -- enable = true,
    --     name = 'rose-pine',
    --     priority = 1000,
    --     config = function()
    --         require('rose-pine').setup {
    --             variant = 'moon',
    --             highlight_groups = {
    --                 IndentBlanklineChar = { fg = '#333142' },
    --                 IndentBlanklineSpaceChar = { fg = '#333142' },
    --                 IndentBlanklineSpaceCharBlankline = { fg = '#333142' },
    --             },
    --         }
    --         vim.cmd 'colorscheme rose-pine'
    --     end,
    -- },
    -- {
    --     -- Theme inspired by Atom
    --     'navarasu/onedark.nvim',
    --     enabled = true,
    --     priority = 1000,
    --     config = function()
    --         require('onedark').setup {
    --             colors = {
    --                 bg0 = '#282c33',
    --             },
    --             diagnostics = {
    --                 -- darker = true,     -- darker colors for diagnostic
    --                 undercurl = false, -- use undercurl instead of underline for diagnostics
    --                 background = true, -- use background color for virtual text
    --             },
    --         }
    --         vim.cmd.colorscheme 'onedark'
    --     end,
    -- },
    -- {
    --     'NTBBloodbath/doom-one.nvim',
    --     priority = 1000,
    --     config = function()
    --         -- require('doom-one.nvim').config()
    --
    --         vim.cmd 'colorscheme doom-one'
    --     end,
    -- },
}
