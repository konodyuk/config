local modules = {
	"conf.impatient",
	"conf.options",
	"conf.keymaps",
	"conf.textobjects",
	"conf.lazy",
	"conf.help",
	"conf.tmux",
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
