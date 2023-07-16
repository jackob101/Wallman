---@type ChadrcConfig
local M = {}
M.ui = {
	theme = "everforest",
	cmp = {
		style = "flat_dark",
	},
	nvdash = {
		load_on_startup = true,
	},
	statusline = {
		separator_style = "block",
	},
}
M.plugins = "custom.plugins"
M.mappings = require("custom.mappings")

vim.o.number = true
vim.o.relativenumber = true
vim.diagnostic.config({ virtual_text = false })
vim.o.scrolloff = 15

vim.g.yuck_lisp_indentation = 1

vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "single",
})

return M
