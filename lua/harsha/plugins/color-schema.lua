return {
	-- 1. Download Tokyo Night
	{ "folke/tokyonight.nvim", lazy = false, priority = 1000 },

	-- 2. Download Catppuccin
	{ "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },

	-- 3. Download Kanagawa
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		-- config = function()
		-- 	-- List of clean variations available across your installed plugins
		-- 	local dynamic_themes = {
		-- 		"tokyonight-storm",
		-- 		"tokyonight-night",
		-- 		"tokyonight-day",
		-- 		"catppuccin-mocha",
		-- 		"catppuccin-latte",
		-- 		"kanagawa-wave",
		-- 	}
		--
		-- 	-- Set default theme on first launch
		-- 	vim.cmd.colorscheme("tokyonight-storm")
		--
		-- 	-- Unified toggle function
		-- 	local function cycle_themes()
		-- 		local current = vim.g.colors_name or ""
		-- 		local next_idx = 1
		--
		-- 		-- Find where we are in the rotation list
		-- 		for idx, name in ipairs(dynamic_themes) do
		-- 			if name == current then
		-- 				next_idx = (idx % #dynamic_themes) + 1
		-- 				break
		-- 			end
		-- 		end
		--
		-- 		local new_theme = dynamic_themes[next_idx]
		-- 		local success, _ = pcall(vim.cmd.colorscheme, new_theme)
		--
		-- 		if success then
		-- 			vim.notify("🎨 Theme: " .. new_theme, vim.log.levels.INFO)
		-- 		else
		-- 			vim.cmd.colorscheme("tokyonight")
		-- 		end
		-- 	end
		--
		-- 	-- Bind to <leader>th in Normal Mode
		-- 	vim.keymap.set("n", "<leader>th", cycle_themes, { desc = "Cycle colorschemes" })
		-- end,
	},
	{
		"propet/colorscheme-persist.nvim",
		lazy = false, -- Required: Load on startup to set the colorscheme
		config = true, -- Required: call setup() function
		dependencies = {
			"nvim-telescope/telescope.nvim",
			-- NOTE: Add your colorscheme plugins here if you want lazy.nvim
			-- to manage them directly within this plugin specification.
			-- Otherwise, ensure they are installed elsewhere in your config.
			-- Example:
			-- "folke/tokyonight.nvim",
			-- "rebelot/kanagawa.nvim",
			-- "Th3Whit3Wolf/space-nvim",
		},
		-- Set a keymap to open the picker
		keys = {
			{
				"<leader>sc", -- Or your preferred keymap
				function()
					require("colorscheme-persist").picker()
				end,
				mode = "n",
				desc = "Choose colorscheme",
			},
		},
		-- Optional: Configure the plugin (see Configuration section below)
		opts = {
			-- Add custom options here, for example:
			-- fallback = "space-nvim",
		},
	},
}
