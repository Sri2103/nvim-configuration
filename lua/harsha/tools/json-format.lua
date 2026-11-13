local M = {}

function M.format_json()
	local view = vim.fn.winsaveview()
	vim.cmd(":%!jq . 2>dev/null ")
	-- print("Buffer formatted with jq")
	if vim.v.shell_error ~= 0 then
		vim.cmd([[undo]])
		print("invalid JSON!")
	else
		print("json formatted")
	end

	vim.fn.winrestview(view)
end

return M
