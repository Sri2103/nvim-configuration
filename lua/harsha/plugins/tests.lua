return {
	"vim-test/vim-test",
	config = function()
		-- Run tests inside a neovim terminal split
		vim.g["test#strategy"] = "neovim"

		-- Universal test keymaps
		vim.keymap.set("n", "<Leader>tc", ":TestNearest<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>tf", ":TestFile<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>ta", ":TestSuite<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>tl", ":TestLast<CR>", { silent = true })
		vim.keymap.set("n", "<Leader>tv", ":TestVisit<CR>", { silent = true })
	end,
}
