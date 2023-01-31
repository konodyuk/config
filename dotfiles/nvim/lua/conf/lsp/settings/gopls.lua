return {
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
