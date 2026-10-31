return {
	"ibhagwan/fzf-lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local fzf = require("fzf-lua")
		fzf.setup({
			winopts = {
				height = 0.85,
				width = 0.80,
				preview = {
					layout = "horizontal",
				},
			},
		})

		-- Makes fzf-lua handle standard vim selection menus
		require("fzf-lua").register_ui_select()

		-- fzf -lua keymamps
		--vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find current directory files (fzf-lua)" })
		--vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Fuzzy find active buffers (fzf-lua)" })
		--vim.keymap.set("n", "<leader>pr", fzf.oldfiles, { desc = "Fuzzy find recent files (fzf-lua)" })

		-- live greps
		vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live Grep workspace (fzf-lua)" })
		vim.keymap.set("n", "<leader>pWs", fzf.grep_cword, { desc = "Find Word under cursor (fzf-lua)" })

		-- package searches
		-- vim.keymap.set("n", "<leader>fc", function()
		-- 	fzf.files({ cwd = vim.fn.stdpath("config") })
		-- end, { desc = "Find Neovim Config Files (fzf-lua)" })

		vim.keymap.set("n", "<leader>ep", function()
			fzf.files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
		end, { desc = "Finding neovim installed package files (fzf-lua)" })
	end,
}
