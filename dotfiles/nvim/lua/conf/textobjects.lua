local function run(str)
	return vim.cmd(vim.api.nvim_replace_termcodes(str, true, true, true))
end

function _TEXTOBJECT_PARAGRAPH_BACKWARD()
	--[[ print(vim.v.count) ]]
	--[[ vim.api.nvim_feedkeys("}", "N", false) ]]
	--[[ vim.api.nvim_command("normal! 0V") ]]
	--[[ vim.api.nvim_feedkeys(string.format("%d{", vim.v.count), "", false) ]]
	--[[ vim.api.nvim_feedkeys(string.format("%dap", vim.v.count), "", false) ]]
	--[[ vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true) ]]
	--[[ vim.api.nvim_input("<Esc>") ]]
	if vim.v.count > 1 then
		local cmd = string.format("normal! <Esc>%d{V%dapo", vim.v.count, vim.v.count)
		-- print(cmd, run(cmd))
		return
	end
	run("normal! <Esc>{Vap")
	--[[ vim.api.nvim_command(string.format("normal! V%dap", vim.v.count)) ]]
end

map("x", "aP", "<cmd>lua _TEXTOBJECT_PARAGRAPH_BACKWARD()<cr>")
map("o", "aP", "<cmd>lua _TEXTOBJECT_PARAGRAPH_BACKWARD()<cr>")

map("x", "il", "g_o^")
map("o", "il", ":normal vil<cr>")
map("x", "al", "$o0")
map("o", "al", ":normal val<cr>")

map("x", "iF", ":normal! G$Vgg0<cr>")
map("o", "iF", ":normal! GVgg<cr>")
map("x", "aF", ":normal! G$Vgg0<cr>")
map("o", "aF", ":normal! GVgg<cr>")

local status_ok, presets = pcall(require, "which-key.plugins.presets")
if status_ok then
	presets.objects["aP"] = [[a paragraph (backwargs)]]
	presets.objects["il"] = [[inner line (content only)]]
	presets.objects["al"] = [[a line (including whitespace)]]
	presets.objects["aF"] = [[a file (entire buffer)]]
	presets.objects["iF"] = [[inside file (entire buffer)]]
end
