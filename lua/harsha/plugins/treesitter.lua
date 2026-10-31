return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		branch = "main",
		config = function()
			-- FIXED: 'nvim-treesitter.configs' module is deleted on 'main' branch.
			-- We call setup directly from the root module using the new configuration format.
			require("nvim-treesitter").setup({
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},

				indent = { enable = true },

				ensure_installed = {
					"json", "javascript", "typescript", "tsx", "go", "yaml",
					"html", "css", "python", "http", "prisma", "markdown",
					"markdown_inline", "svelte", "graphql", "bash", "lua",
					"vim", "dockerfile", "gitignore", "query", "vimdoc",
					"c", "java", "rust", "ron",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
			})
		end,
	},
	-- NOTE: js,ts,jsx,tsx Auto Close Tags
	{
		"windwp/nvim-ts-autotag",
		enabled = true,
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,           -- Auto-close tags
					enable_rename = true,          -- Auto-rename pairs
					enable_close_on_slash = false, -- Disable auto-close on trailing `</`
				},
				per_filetype = {
					["html"] = {
						enable_close = true,
					},
					["typescriptreact"] = {
						enable_close = true,
					},
				},
			})
		end,
	},
    {
        "stevearc/aerial.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require("aerial").setup({})
            require("telescope").load_extension('aerial')
        end
    }
}
