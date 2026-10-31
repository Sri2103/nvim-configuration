return {
	"mfussenegger/nvim-lint",
	-- load the plugin when opening an existing file or creating a new one
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local status_ok, lint = pcall(require, "nvim-lint")
		if not status_ok then
			return
		end


		-- local lint = require("nvim-lint")

		-- 1. Map your linters to specific language
		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" }, -- FIXED: Removed the underscore
			html = { "tidy" },
			css = { "stylelint" },
			scss = { "stylelint" },
			python = { "ruff" },
			lua = { "luacheck" },
			go = { "golangci-lint" },
			bash = { "shellcheck" },
			sh = { "shellcheck" },
			json = { "jsonlint" },
			yaml = { "yamllint" },
			markdown = { "markdownlint" },
			dockerfile = { "hadolint" },
		}

		lint.linters.luacheck.args = {
			"--globals",
			"vim",
			"--formatter",
			"plain",
			"--codes",
		}

		if lint.linters.ruff then
			lint.linters.ruff.args = {
				"check",
				"--force-exclude",
				"--quiet",
				"--output-format",
				"json",
				"--stdin-filename",
				function()
					return vim.api.nvim_buf_get_name(0)
				end,
			}
		end

		--2. Create a clean autocommand group to avoid duplication
		local lint_augroup = vim.api.nvim_create_augroup("linting_on_save", { clear = true })

		-- 3. Trigger linting automatically on these buffer events
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
			group = lint_augroup,
			callback = function()
				if vim.bo.modifiable and vim.bo.buftype == "" then
					lint.try_lint()
				end
			end,
		})

		-- FIXED: Initialize Mason core before setting up the installer
		require("mason").setup()

		require("mason-tool-installer").setup({
			ensure_installed = {
				"eslint_d",
				"html-tidy",
				"stylelint",
				"ruff",
				"golangci-lint",
				"shellcheck",
				"luacheck",
				"jsonlint",
				"yamllint",
				"markdownlint",
				"hadolint",
			},
			auto_update = true,
			run_on_start = true,
		})
	end,
}
