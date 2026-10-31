return {
	"nvim-telescope/telescope.nvim",
	branch = "master", -- using master to fix issues with deprecated to definition warnings
	-- '0.1.x' for stable ver.
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build =
			"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install",
		},
		"nvim-tree/nvim-web-devicons",
		"andrew-george/telescope-themes",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.load_extension("fzf")
		telescope.load_extension("themes")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
					},
				},
			},
			extensions = {
				themes = {
					enable_previewer = true,
					enable_live_preview = true,
					persist = {
						enabled = true,
						path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua",
					},
				},
			},
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>a", "<cmd>Telescope aerial<cr>", { desc = "File code  outline (aerial)" })
		vim.keymap.set(
			"n",
			"<leader>ff",
			require("telescope.builtin").find_files,
			{ desc = "find current directory files" }
		)
		vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "find tags help" })
		vim.keymap.set("n", "<leader>pr", "<cmd>Telescope oldfiles<CR>", { desc = "Fuzzy find recent files" })
		-- vim.keymap.set("n", "<leader>pWs", function()
		-- 	local word = vim.fn.expand("<cWORD>")
		-- 	builtin.grep_string({ search = word })
		-- end, { desc = "Find Connected Words under cursor" })

		vim.keymap.set(
			"n",
			"<leader>ths",
			"<cmd>Telescope themes<CR>",
			{ noremap = true, silent = true, desc = "Theme Switcher" }
		)
		vim.keymap.set("n", "<leader>ep", function()
			require("telescope.builtin").find_files({
				cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
			})
		end, { desc = "finding neovim installed package  files" })

		vim.keymap.set("n", "<leader>fk", require("telescope.builtin").keymaps, { desc = "Find/view keymamps" })

		vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "fuzzy find active buffers" })

		-- Press Space + fc (Find Config) to instantly search your Neovim configuration files
		vim.keymap.set("n", "<leader>fc", function()
			require("telescope.builtin").find_files({
				cwd = vim.fn.stdpath("config"),
				prompt_title = "Neovim Config Files",
			})
		end, { desc = "Find Neovim Config Files" })
	end,
}
