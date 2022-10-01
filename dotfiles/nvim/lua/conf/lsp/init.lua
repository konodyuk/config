local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("conf.lsp.lsp-installer")
require("conf.lsp.handlers").setup()
require("conf.lsp.null-ls")
require("conf.lsp.snippets")
require("conf.lsp.docstrings")
