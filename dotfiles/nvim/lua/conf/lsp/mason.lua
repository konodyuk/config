local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	return
end

local mason_lsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lsp_ok then
	return
end

mason.setup()
mason_lspconfig.setup()

local lsp_ok, lspconfig = pcall(require, "lspconfig")
if not lsp_ok then
	return
end

local opts = {}

for _, server in pairs(mason_lspconfig.get_installed_servers()) do
	opts = {
		on_attach = require("conf.lsp.handlers").on_attach,
		capabilities = require("conf.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "conf.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end
