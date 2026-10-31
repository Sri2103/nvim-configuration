return {
	{

		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },

		dependencies = {

			"williamboman/mason.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},

		config = function()
			--- 1. Map filetypes to Formatters (Language tier arch)
			local conform = require("conform")

			conform.setup({

				formatters_by_ft = {

					javascript = { "prettierd", "prettier", stop_after_first = true },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
					html = { "prettier" },
					css = { "prettier" },
					scss = { "prettier" },

					--- Data & backend
					python = { "ruff_organize_imports", "ruff_format", "ruff_fix" },
					go = { "goimports", "gofumpt" },
					rust = { "rustfmt" },

					-- system and scripting
					bash = { "shfmt" },
					sh = { "shfmt" },
					zsh = { "shfmt" },
					lua = { "stylua" },

					-- Data formats and devops

					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					dockerfile = { "dockerfmt" },
				},

				format_on_save = {
					lsp_format = "fallback",
					timeout_ms = 3000,
				},

				formatters = {

					shfmt = {
						prepend_args = { "-i", "2" },
					},

					stylua = {
						prepend_args = { "--column-width", "120", "--line-endings=Unix" },
					},
				},
			})

			require("mason-tool-installer").setup({

				ensure_installed = {
					"prettierd",
					"prettier",

					-- backend tools
					"ruff",
					"goimports",
					"gofumpt",
					-- scripting
					"shfmt",
					"stylua",
				},
			})
		end,
	},
}
