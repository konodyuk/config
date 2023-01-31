local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = require("conf.lsp.handlers").on_attach,
		capabilities = require("conf.lsp.handlers").capabilities,
	}

	if server.name == "sumneko_lua" then
		local sumneko_opts = require("conf.lsp.settings.sumneko_lua")
		opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
	end

	if server.name == "gopls" then
		-- ref: https://github.com/neovim/nvim-lspconfig/issues/804#issuecomment-1274928702
		local gopls_opts = {
			root_dir = function(fname)
				local nvim_lsp = require("lspconfig")
				local lastRootPath = nil
				local gomodpath = vim.trim(vim.fn.system("go env GOPATH")) .. "/pkg/mod"
				local fullpath = vim.fn.expand(fname, ":p")
				if string.find(fullpath, gomodpath) and lastRootPath ~= nil then
					return lastRootPath
				end
				local root = nvim_lsp.util.root_pattern("go.mod", ".git")(fname)
				if root ~= nil then
					lastRootPath = root
				end
				-- fix: root -> lastRootPath
				return lastRootPath
			end,
		}
		opts = vim.tbl_deep_extend("force", gopls_opts, opts)
	end

	-- This setup() function is exactly the same as lspconfig's setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	server:setup(opts)
end)
