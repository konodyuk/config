local modules = {
	"conf.impatient",
	"conf.options",
	"conf.keymaps",
	"conf.textobjects",
	"conf.plugins",
	"conf.colorscheme",
	"conf.cmp",
	"conf.lsp",
	"conf.telescope",
	"conf.codi",
	"conf.iron",
	"conf.misc",
	"conf.treesitter",
	"conf.neotree",
	"conf.autopairs",
	"conf.comment",
	"conf.gitsigns",
	"conf.whichkey",
	"conf.lualine",
	"conf.toggleterm",
	"conf.bufferline",
	"conf.dial",
	-- "conf.symbols-outline",
}

local err_modules = {}

for _, name in ipairs(modules) do
	local status, _ = pcall(require, name)
	if not status then
		table.insert(err_modules, name)
	end
end

if not (next(err_modules) == nil) then
	print(" ")
	print("The following modules failed to load:")
	for _, name in ipairs(err_modules) do
		print("- " .. name)
	end
end
