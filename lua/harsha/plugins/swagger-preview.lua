return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"b0o/SchemaStore.nvim",
		},
		config = function()
			-- local lspconfig = require("lspconfig")
			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						schemaStore = {
							enable = false,
							-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
							url = "",
						},
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			})
			vim.lsp.enable("yamlls")
		end,
	},

	{
		"vinnymeller/swagger-preview.nvim",
		cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
		build = "npm i", -- Automatically builds using the Node/npm you just installed
		config = function()
			require("swagger-preview").setup({
				port = 8000,
				host = "localhost",
			})
		end,
	},
}
