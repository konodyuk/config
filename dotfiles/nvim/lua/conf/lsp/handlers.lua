local wk = require("which-key")

local M = {}

-- TODO: backfill this to template
M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		-- disable virtual text
		virtual_text = false,
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

function _SMART_SIGNATURE_HELP()
	vim.lsp.buf.hover()
	vim.lsp.buf.signature_help()
end

local function lsp_keymaps(bufnr)
	-- ref: https://github.com/folke/dot/blob/master/config/nvim/lua/config/plugins/lsp/keys.lua
	wk.register({
		buffer = bufnr,
		g = {
			name = "+goto",
			D = { "<cmd>Telescope lsp_declarations initial_mode=normal<cr>", "Declaration" },
			d = { "<cmd>Telescope lsp_definitions initial_mode=normal<cr>", "Definition" },
			i = { "<cmd>Telescope lsp_implementations initial_mode=normal<cr>", "Implementations" },
			t = { "<cmd>Telescope lsp_type_definitions initial_mode=normal<cr>", "Type Definitions" },
			r = { "<cmd>Telescope lsp_references initial_mode=normal<cr>", "References" },
			l = { '<cmd>lua vim.diagnostic.open_float({ border = "rounded", focusable = true })<CR>', "Diagnostic" },
		},
		K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
		["<C-s>"] = { "<cmd>lua _SMART_SIGNATURE_HELP()<cr>", "Signature Help" },
		["[d"] = {
			'<cmd>lua vim.diagnostic.goto_prev({ border = "rounded", focusable = true })<CR>',
			"Prev Diagnostic",
		},
		["]d"] = {
			'<cmd>lua vim.diagnostic.goto_next({ border = "rounded", focusable = true })<CR>',
			"Next Diagnostic",
		},
	})
	wk.register({
		["<C-s>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
	}, { mode = "i" })
	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
end

M.on_attach = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
	lsp_keymaps(bufnr)
end

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	return
end

M.capabilities = cmp_nvim_lsp.default_capabilities()

return M
