return {
	-- 1. Configuration for nvim-cmp and cmp-cmdline
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-cmdline", -- The command line completion source
			"hrsh7th/cmp-buffer", -- Buffer completions for search
			"hrsh7th/cmp-path", -- File system path completions
		},
		config = function()
			local cmp = require("cmp")

			-- Standard Insert Mode Completion (Minimal example for context)
			-- cmp.setup({
			--   mapping = cmp.mapping.preset.insert({
			--     ["<C-b>"] = cmp.mapping.scroll_docs(-4),
			--     ["<C-f>"] = cmp.mapping.scroll_docs(4),
			--     ["<C-Space>"] = cmp.mapping.complete(),
			--     ["<CR>"] = cmp.mapping.confirm({ select = false }),
			--   }),
			--   sources = cmp.config.sources({
			--     { name = "buffer" },
			--   }),
			-- })
			--
			-- ==========================================
			-- SEARCH COMPLETION (For when you press / or ?)
			-- ==========================================
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- ==========================================
			-- COMMAND LINE COMPLETION (For when you press :)
			-- ==========================================
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline({
					-- CRITICAL MAPPING: Safe Enter key behavior in Noice cmdline
					["<CR>"] = cmp.mapping({
						c = function(fallback)
							if cmp.visible() then
								cmp.confirm({ select = true })
							else
								fallback()
							end
						end,
					}),
				}),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" }, -- Avoid cluttering with system binaries
						},
					},
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},

	-- 2. Configuration for noice.nvim
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = false, -- Clean floating search box
				command_palette = true, -- Centers the command bar and cmp menu together
				long_message_to_split = true, -- Puts massive logs into a split buffer
				lsp_doc_border = true, -- Adds a border to hover docs
			},
			routes = {
				-- Filter out routine "written" logs from nvim-notify
				{
					filter = { event = "msg_show", kind = "", find = "written" },
					opts = { skip = true },
				},
			},
		},
		keys = {
			{
				"<leader>nd",
				function()
					require("noice").cmd("dismiss")
				end,
				desc = "Dismiss Notifications",
			},
			{
				"<leader>nh",
				function()
					require("noice").cmd("history")
				end,
				desc = "Show Message History",
			},
		},
	},
}
