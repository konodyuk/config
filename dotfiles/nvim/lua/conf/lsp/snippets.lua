local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

local snippets_root = os.getenv("NVIM_EXTERNAL_SNIPPETS")
if not snippets_root then
	return
end

-- Path api: https://github.com/L3MON4D3/LuaSnip/blob/master/lua/luasnip/util/path.lua
local Path = require("luasnip.util.path")
snippets_root = Path.expand(snippets_root)

local _, ft_dirs = Path.scandir(snippets_root)

local ASYNC = false

local function add_snippet(filetype, name, content)
	-- local lines = vim.split(content, "\n")

	local lines = {}
	for line in string.gmatch(content, "[^\n]+") do
		table.insert(lines, line)
	end

	luasnip.add_snippets(filetype, {
		luasnip.snippet(name, luasnip.text_node(lines)),
	})
end

for _, ft_dir in ipairs(ft_dirs) do
	local file_paths, _ = Path.scandir(ft_dir)
	local filetype = Path.basename(ft_dir)

	for _, file_path in ipairs(file_paths) do
		local filename, _ = Path.basename(file_path, true)

		if ASYNC then
			Path.async_read_file(file_path, function(content)
				add_snippet(filetype, filename, content)
			end)
		else
			local content = Path.read_file(file_path)
			add_snippet(filetype, filename, content)
		end
	end
end
