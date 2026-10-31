return {
	"folke/trouble.nvim",
	opts = {
		auto_close = false, -- Auto close when there are no items
		auto_open = false, -- Auto open when there are items
		auto_preview = true, -- Automatically preview item location when navigating
		auto_refresh = true, -- Auto refresh when open
		auto_jump = false, -- Auto jump to the first item when there's only one
		focus = true, -- Focus the trouble window when opened
		restore = true, -- Restore the last trouble position when reopening
		follow = true, -- Follow the current item
		indent_guides = true, -- Show indent guides
		max_items = 200, -- Limit number of displayed items
		multiline = true, -- Render multi-line messages
		pinned = false, -- Pinned trouble window
		win = {
			position = "bottom", -- "bottom", "top", "left", "right"
			size = 12,
		},
		preview = {
			type = "main",
			scratch = true,
		},
		-- Use nicer icons or match your Nerd Font
		icons = {
			source = "lsp",
		},
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Workspace Diagnostics (Trouble)",
		},
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / References / Impl (Trouble)",
		},
		{
			"<leader>xL",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>xQ",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
}
