return {
	{
		"tpope/vim-dadbod",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_navigation = 1

			-- 1. Setup Cross-Platform paths
			local config_path = vim.fn.stdpath("config")
			local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
			vim.g.db_ui_save_location = config_path .. (is_windows and "\\db_ui" or "/db_ui")

			-- Quick helper function to trim whitespace if your string has trailing spaces
			function string.trim(s)
				return s:match("^%s*(.-)%s*$")
			end

			-- 2. DYNAMIC LOOKUP: Read local .env file if it exists
			local env_file = vim.fn.getcwd() .. (is_windows and "\\.env" or "/.env")
			if vim.fn.filereadable(env_file) == 1 then
				for line in io.lines(env_file) do
					-- Matches lines like DATABASE_URL="postgresql://..." or DATABASE_URL=postgresql://...
					local key, val = line:match("^([^=]+)=(.*)$")
					if key and (key:trim() == "DATABASE_URL" or key:trim() == "DB_DEV") then
						-- Clean up any surrounding quotes from the connection string
						local clean_url = val:gsub('^"', ""):gsub('"$', ""):gsub("^'", ""):gsub("'$", ""):trim()

						-- Inject directly into Neovim's environment memory
						vim.env.PROJECT_DB = clean_url
					end
				end
			end

			-- 3. Auto-trigger completion
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					require("cmp").setup.buffer({
						sources = { { name = "vim-dadbod-completion" } },
					})
				end,
			})
		end,
		keys = {
			{ "<leader>du", "<cmd>DBUIToggle<cr>", desc = "Toggle Dadbod UI" },
		},
	},
}
