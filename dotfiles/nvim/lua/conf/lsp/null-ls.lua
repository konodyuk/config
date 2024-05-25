return function()
	local null_ls_status_ok, null_ls = pcall(require, "null-ls")
	if not null_ls_status_ok then
		return
	end

	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics

	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	null_ls.setup({
		--[[ default_timeout = 10000, ]]
		debug = false,
		sources = {
			formatting.prettier,
			formatting.isort,
			formatting.black,
			formatting.stylua,
			formatting.gofmt,
			formatting.shfmt.with({ extra_args = { "-i", "4" } }),
			formatting.clang_format.with({
				extra_args = { "-style", "{IndentWidth: 4, ColumnLimit: 300}" },
			}),
			formatting.terraform_fmt,
			null_ls.builtins.code_actions.gitsigns,
		},
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
						vim.lsp.buf.format({ bufnr = bufnr })
					end,
				})
			end
		end,
	})
end
