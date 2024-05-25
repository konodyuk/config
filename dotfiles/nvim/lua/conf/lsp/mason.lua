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

local status_ok, registry = pcall(require, "mason-registry")
if not status_ok then
	return
end

local function install_package(name)
	if not registry.has_package(name) then
		print("Setup: Invalid package: " .. name)
		return
	end
	if registry.is_installed(name) then
		print("Setup: Already installed: " .. name)
		return
	end
	local pkg = registry.get_package(name)
	print("Setup: Installing: " .. name)
	pkg:install()
end

vim.api.nvim_create_user_command("SetupPython", function()
	install_package("pyright")
	install_package("debugpy")
	install_package("black")
	install_package("isort")
end, { force = true })

vim.api.nvim_create_user_command("SetupGolang", function()
	install_package("gopls")
	install_package("delve")
end, { force = true })

vim.api.nvim_create_user_command("SetupMarkdown", function()
	install_package("marksman")
end, { force = true })

vim.api.nvim_create_user_command("SetupFrontend", function()
	install_package("typescript-language-server")
	install_package("prettier")
end, { force = true })

vim.api.nvim_create_user_command("SetupBash", function()
	install_package("bash-language-server")
	install_package("beautysh")
end, { force = true })

vim.api.nvim_create_user_command("SetupLua", function()
	install_package("lua-language-server")
	install_package("stylua")
end, { force = true })

vim.api.nvim_create_user_command("SetupCpp", function()
	install_package("clangd")
	install_package("clang-format")
end, { force = true })

vim.api.nvim_create_user_command("SetupMarkups", function()
	install_package("yaml-language-server")
	install_package("json-lsp")
end, { force = true })
