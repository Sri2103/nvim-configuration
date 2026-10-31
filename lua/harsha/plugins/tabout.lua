return {
	"abecodes/tabout.nvim",
	lazy = true,
	event = "InsertEnter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"hrsh7th/nvim-cmp",
	},
	opts = {
		tabkey = "", -- DISABLED: Handled manually by nvim-cmp
		backwards_tabkey = "", -- DISABLED: Handled manually by nvim-cmp
		act_as_tab = true, -- Shift into normal tab behavior if not inside a pair
		act_as_shift_tab = true, -- Shift into normal shift-tab behavior
		default_tab = "<C-t>", -- Fallback mapping for standard tab behavior
		default_shift_tab = "<C-d>", -- Fallback mapping for standard shift-tab behavior
		enable_backwards = true, -- Allow backward tabbing
		completion = true, -- Coordinates internal timing with completion menus
		tabouts = {
			{ open = "'", close = "'" },
			{ open = '"', close = '"' },
			{ open = "`", close = "`" },
			{ open = "(", close = ")" },
			{ open = "[", close = "]" },
			{ open = "{", close = "}" },
		},
		ignore_beginning = true, -- Allows tabbing out even if the cursor is at the start of a pair
		exclude = {}, -- Add any filetypes where you want this disabled
	},
}
