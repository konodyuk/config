local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

require("lsp_signature").setup({
	hint_enable = false,
	handler_opts = {
		border = "single",
	},
	max_width = 80,
})

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

--   פּ ﯟ   some other good icons
local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- ["<Space>"] = cmp.mapping({
		-- 	i = cmp.mapping.abort(),
		-- 	c = cmp.mapping.close(),
		-- }),
		-- ["<C-Space>"] = cmp.mapping({
		-- 	i = cmp.mapping(function(fallback)
		-- 		if cmp.visible() then
		-- 			cmp.mapping.abort()
		-- 			fallback()
		-- 		else
		-- 			cmp.mapping.complete()
		-- 		end
		-- 	end),
		-- 	c = cmp.mapping(function(fallback)
		-- 		if cmp.visible() then
		-- 			cmp.mapping.close()
		-- 			fallback()
		-- 		else
		-- 			cmp.mapping.complete()
		-- 		end
		-- 	end),
		-- }),
		-- ["<leader><CR>"] = cmp.mapping({
		-- 	i = cmp.mapping(function(fallback)
		-- 		-- print("kek")
		-- 		cmp.mapping.abort()
		-- 		-- fallback()
		-- 		-- vim.cmd(vim.api.nvim_replace_termcodes("<cr>", true, true, true))
		-- 		-- vim.api.nvim_create_buf
		-- 		vim.cmd("normal! a\n")
		-- 	end),
		-- 	-- c = cmp.mapping(function(fallback)
		-- 	-- 	cmp.mapping.close()
		-- 	-- 	-- fallback()
		-- 	-- 	vim.cmd(vim.api.nvim_replace_termcodes("<cr>", true, true, true))
		-- 	-- end),
		-- }),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif require("neogen").jumpable() then
				require("neogen").jump_next()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif check_backspace() then
				fallback()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif require("neogen").jumpable(true) then
				require("neogen").jump_prev()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<C-l>"] = cmp.mapping(function(fallback)
			if require("neogen").jumpable() then
				require("neogen").jump_next()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<C-h>"] = cmp.mapping(function(fallback)
			if require("neogen").jumpable(true) then
				require("neogen").jump_prev()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			vim_item.menu = ({
				-- nvim_lsp_signature_help = "[SIG]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[NVIM_LUA]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
	sources = {
		-- { name = 'nvim_lsp_signature_help' },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path", option = {
			trailing_slash = true,
		} },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
		-- documentation = {
		--   border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		-- },
		documentation = cmp.config.window.bordered(),
	},
	experimental = {
		ghost_text = false,
		native_menu = false,
	},
	-- completion = {
	-- 	keyword_length = 2,
	-- },
	-- preselect = cmp.PreselectMode.None,
})
