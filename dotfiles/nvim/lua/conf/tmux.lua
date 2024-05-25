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

local function send_lines_to_tmux_pane(pane_id, lines)
	table.insert(lines, "\n")
	local text = table.concat(lines, "\n")
	local bracketed_text = "\x1b[200~" .. text .. "\x1b[201~"
	local cmd = "tmux send-keys -t " .. pane_id .. " " .. vim.fn.shellescape(bracketed_text) .. " Enter"
	os.execute(cmd)
end

local function mark_and_send_motion(mtype)
	local text = require("iron.core").mark_motion(mtype)
	local pane_id = get_adjacent_pane_id()
	if pane_id then
		send_lines_to_tmux_pane(pane_id, text)
	end
end

vim.api.nvim_create_user_command("TmuxSendToAdjacentPaneOp", function()
	local pane_id = get_adjacent_pane_id()
	if pane_id then
		require("iron.marks").winsaveview()
		vim.o.operatorfunc = "v:lua.require'conf.tmux'.mark_motion"
		vim.api.nvim_feedkeys("g@", "ni", false)
	else
		print("No adjacent pane found")
	end
end, { range = true })

vim.api.nvim_create_user_command("TmuxSendToAdjacentPaneVisual", function()
	local pane_id = get_adjacent_pane_id()
	if pane_id then
		local text = require("iron.core").mark_visual()
		send_lines_to_tmux_pane(pane_id, text)
	end
end, {})

return { mark_motion = mark_and_send_motion }
