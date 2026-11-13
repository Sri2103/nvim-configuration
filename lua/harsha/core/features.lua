vim.diagnostic.config({
	float = {
		focus = true,
		border = "rounded",
	},
})

if vim.fn.has("wsl") == 1 then
	vim.g.clipboard = {
		name = "win32yank-wsl",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 0,
	}
end

local configPath = vim.fs.normalize(vim.fn.stdpath("config"))
-- autoreload vim config
vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("AutoReloadConfig", { clear = true }),
	pattern = configPath .. "/**/*.lua",
	callback = function()
		vim.cmd.restart()
	end,
})

vim.filetype.add({
	extension = {
		mmd = "mermaid",
		mermaid = "mermaid",
	},
})
