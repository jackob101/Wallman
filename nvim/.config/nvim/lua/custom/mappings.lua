local M = {}

M.lsp = {
  n = {
    ["<leader>ld"] = { "<cmd>Telescope diagnostics bufnr=0<CR>", "Show current buffer diagnostics" },
    ["<leader>la"] = { "<cmd> lua vim.lsp.buf.code_action()<cr>", "Show code actions" },
    ["<leader>lp"] = { "<cmd> lua vim.diagnostic.goto_prev()<cr>", "Go to previous error" },
    ["<leader>ln"] = { "<cmd> lua vim.diagnostic.goto_next()<cr>", "Go to next error" },
    ["<leader>lh"] = { "<cmd> lua vim.lsp.buf.hover()<cr>", "Hover" },
    ["<leader>ls"] = { "<cmd> lua vim.lsp.buf.signature_help()<cr>", "Hover" },
    ["<leader>lr"] = { "<cmd> lua vim.lsp.buf.rename()<cr>", "Rename" },
  },
}

M.git = {
  n = {
    ["<leader>gg"] = { "<cmd>lua _LAZYGIT_TOGGLE()<cr>", "Open Lazy Git" },
  },
}

return M
