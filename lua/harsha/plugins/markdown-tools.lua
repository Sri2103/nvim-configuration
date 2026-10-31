return {
	-- 1. Visual enhancement inside Neovim
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- or nvim-web-devicons
		ft = { "markdown" },
		opts = {
			heading = {
				sign = false, -- Disable left sign column marks if preferred
				icons = { "   ", "   ", "   ", "   ", "   ", "   " },
			},
			checkbox = {
				enabled = true,
			},
			pipe_table = {
				preset = "round", -- Smooth grid lines for tables
			},
		},
		keys = {
			{ "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Rendering" },
		},
	},

	-- 2. Browser Preview Engine
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
		keys = {
			{ "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Browser Preview" },
		},
	},

	-- 3. Flow and Navigation
	{
		"jakewvincent/mkdnflow.nvim",
		ft = { "markdown" },
		config = function()
			require("mkdnflow").setup({
				mappings = {
					MkdnNextLink = { "n", "<Tab>" },
					MkdnPrevLink = { "n", "<S-Tab>" },
					MkdnFollowLink = { "n", "gd" }, -- "Go to Definition" style link following
					MkdnDestroyLink = { "n", "<M-CR>" },
					MkdnTagSpan = { "v", "<M-CR>" },
					MkdnToggleToDo = { { "n", "v" }, "<leader>td" },
				},
			})
		end,
	},
}
