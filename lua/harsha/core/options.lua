vim.cmd("let g:netrw_banner =0")

vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = true

vim.opt.formatoptions:append("tc")
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↪ "

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.incsearch = true -- highlight while searching
vim.opt.inccommand = "split" -- preview when substituting
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.backspace = { "start", "eol", "indent" }

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.textwidth = 80
vim.opt.colorcolumn = "+1"

vim.opt.clipboard = "unnamedplus"
vim.opt.hlsearch = true

vim.opt.mouse = "a"
vim.g.editorconfig = true

-- folding
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- vim.opt.foldlevel = 99
-- vim.opt.foldlevelstart = 99 --
-- vim.opt.foldnestmax = 10 -- dont fold deeper than 10 levels
-- vim.opt.foldcolumn = "1"

function _G.lsp_status()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		return " No LSP"
	end

	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end

	return " " .. table.concat(names, ", ")
end

vim.opt.statusline = "%f %= %{v:lua.lsp_status()}"

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function()
		vim.cmd("redrawstatus")
	end,
})

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "python",
-- 	callback = function()
-- 		vim.opt_local.foldmethod = "indent"
-- 	end,
-- })
