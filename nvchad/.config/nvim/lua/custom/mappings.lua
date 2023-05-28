local M = {}

M.lazygit = {
  n = {
    ["<leader>gg"] = { "<cmd>LazyGit<cr>", "Open lazy git" },
  },
}

M.lsp_custom = {
  plugin = true,
  n = {
    ["<C-x>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Toggle signature help" },
    ["gr"] = { "<cmd>Telescope lsp_references<cr>", "Go to references" },
  },
  i = {
    ["<C-x>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Toggle signature help" },
  },
}

M.lspconfig = {
  n = {

    ["<leader>f"] = {
      function()
        vim.diagnostic.open_float { border = "single" }
      end,
      "Floating diagnostic",
    },

    ["[d"] = {
      function()
        vim.diagnostic.goto_prev { float = { border = "single" } }
      end,
      "Goto prev",
    },

    ["]d"] = {
      function()
        vim.diagnostic.goto_next { float = { border = "single" } }
      end,
      "Goto next",
    },
  },
}

M.hop = {
  n = {
    ["<leader>j"] = {
      "<cmd>HopChar2<cr>",
      "Hop",
    },
  },
}

M.trouble = {
  plugin = true,
  n = {
    ["<leader>q"] = {
      "<cmd>TroubleToggle document_diagnostics<cr>",
      "Document diagnostics",
    },
  },
}

return M
