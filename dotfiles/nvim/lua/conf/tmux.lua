-- local function get_adjacent_pane_id()
-- 	local handle = io.popen("tmux display-message -p '#{pane_id}'")
-- 	if handle == nil then
-- 		return nil
-- 	end
-- 	local current_pane_id = handle:read("*a")
-- 	handle:close()
-- 	current_pane_id = current_pane_id:gsub("%s+", "")
--
-- 	handle = io.popen("tmux list-panes -F '#{pane_id}'")
-- 	if handle == nil then
-- 		return nil
-- 	end
-- 	local panes = handle:read("*a")
-- 	handle:close()
--
-- 	for pane_id in string.gmatch(panes, "%%[%d]+") do
-- 		if pane_id ~= current_pane_id then
-- 			return pane_id
-- 		end
-- 	end
--
-- 	return nil
-- end
--
-- local function send_to_tmux_pane(pane_id)
-- 	local start_pos = vim.fn.getpos("'<")
-- 	local end_pos = vim.fn.getpos("'>")
-- 	local lines = vim.fn.getline(start_pos[2], end_pos[2])
-- 	print("tmux send lines" .. start_pos[2] .. end_pos[2])
-- 	local text = table.concat(lines, "\\n")
-- 	print("tmux send text" .. text)
-- 	local cmd = "tmux send-keys -t " .. pane_id .. " " .. vim.fn.shellescape(text)
-- 	os.execute(cmd)
-- end
--
-- vim.api.nvim_create_user_command("TmuxSendToAdjacent", function()
-- 	local pane_id = get_adjacent_pane_id()
-- 	if pane_id then
-- 		send_to_tmux_pane(pane_id)
-- 	else
-- 		print("No adjacent pane found")
-- 	end
-- end, {})
--
-- local function get_adjacent_pane_id()
-- 	local handle = io.popen("tmux display-message -p '#{pane_id}'")
-- 	if handle == nil then
-- 		return nil
-- 	end
-- 	local current_pane_id = handle:read("*a")
-- 	handle:close()
-- 	current_pane_id = current_pane_id:gsub("%s+", "")
--
-- 	handle = io.popen("tmux list-panes -F '#{pane_id}'")
-- 	if handle == nil then
-- 		return nil
-- 	end
-- 	local panes = handle:read("*a")
-- 	handle:close()
--
-- 	for pane_id in string.gmatch(panes, "%%[%d]+") do
-- 		if pane_id ~= current_pane_id then
-- 			return pane_id
-- 		end
-- 	end
--
-- 	return nil
-- end
--
-- local function send_to_tmux_pane(pane_id, text)
-- 	local bracketed_text = "\x1b[200~" .. text .. "\x1b[201~" -- Enclose text in bracketed paste mode markers
-- 	local cmd = "tmux send-keys -t " .. pane_id .. " " .. vim.fn.shellescape(bracketed_text) .. " Enter"
-- 	os.execute(cmd)
-- end
--
-- vim.api.nvim_create_user_command("TmuxSendToAdjacent", function()
-- 	local pane_id = get_adjacent_pane_id()
-- 	if pane_id then
-- 		local start_pos = vim.fn.getpos("'<")
-- 		local end_pos = vim.fn.getpos("'>")
-- 		local lines = vim.fn.getline(start_pos[2], end_pos[2])
-- 		local text = table.concat(lines, "\n")
-- 		send_to_tmux_pane(pane_id, text)
-- 	else
-- 		print("No adjacent pane found")
-- 	end
-- end, {})

local function get_adjacent_pane_id()
	local handle = io.popen("tmux display-message -p '#{pane_id}'")
	if not handle then
		return nil
	end

	local current_pane_id = handle:read("*a")
	handle:close()
	current_pane_id = current_pane_id:gsub("%s+", "")

	handle = io.popen("tmux list-panes -F '#{pane_id}'")
	if not handle then
		return nil
	end

	local panes = handle:read("*a")
	handle:close()

	for pane_id in string.gmatch(panes, "%%[%d]+") do
		if pane_id ~= current_pane_id then
			return pane_id
		end
	end

	return nil
end

local function send_to_tmux_pane(pane_id, lines)
	table.insert(lines, "\n")
	local text = table.concat(lines, "\n")
	local bracketed_text = "\x1b[200~" .. text .. "\x1b[201~"
	local cmd = "tmux send-keys -t " .. pane_id .. " " .. vim.fn.shellescape(bracketed_text) .. " Enter"
	os.execute(cmd)
end

local function get_visual_selection()
	vim.cmd('normal! gv"xy') -- Reselect and yank to "x" register
	return vim.fn.getreg("x")
end

vim.api.nvim_create_user_command("TmuxSendToAdjacent", function()
	local pane_id = get_adjacent_pane_id()
	if pane_id then
		-- local text = get_visual_selection()
		local lines = require("iron.core").mark_motion()
		if lines == nil then
			return nil
		end
		print("text " .. lines)
		send_to_tmux_pane(pane_id, lines)
		vim.cmd("normal! <Esc>") -- Exit visual mode
	else
		print("No adjacent pane found")
	end
end, {})

-- Operator-pending mode command
-- vim.api.nvim_create_user_command("TmuxMarkMotion", function()
function mark_motion()
	require("iron.marks").winsaveview()
	local text = require("iron.core").mark_motion()
	local pane_id = get_adjacent_pane_id()
	if pane_id then
		send_to_tmux_pane(pane_id, text)
	end
	-- print("text " .. text[1])
end
-- end, { range = true })

function send_keys()
	vim.o.operatorfunc = "v:lua.require'conf.tmux'.mark_motion"
	vim.api.nvim_feedkeys("g@", "ni", false)
end

-- Operator-pending mode command
vim.api.nvim_create_user_command("TmuxSendToAdjacentOp", function()
	local pane_id = get_adjacent_pane_id()
	if pane_id then
		-- vim.cmd("normal! gvy") -- Yank the text covered by the operator
		-- local text = vim.fn.getreg("0")
		-- local text = require("iron.core").mark_motion()
		send_keys()
		-- print("text " .. text[0])
		-- send_to_tmux_pane(pane_id, text[0])
	else
		print("No adjacent pane found")
	end
end, { range = true })

return { mark_motion = mark_motion }
