return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		local signs = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = "⚑",
		}

		vim.diagnostic.config({
			signs = { text = signs },
			virtual_text = true,
			underline = true,
			update_in_insert = false,
		})

		-- Setup Servers Capabilities Integration
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		vim.lsp.config("*", { capabilities = capabilities })

		-- ----------------------------------------------------
		-- SERVER DEFINITIONS
		-- ----------------------------------------------------

		-- Lua Server Setup
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					hint = { enable = true, arrayIndex = "Disable", setType = true }, -- Crucial configuration line for Lua Inlay Hints
					diagnostics = { globals = { "vim" } },
					completion = { callSnippet = "Replace" },
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})
		vim.lsp.enable("lua_ls")

		-- Emmet Language Server Setup
		vim.lsp.config("emmet_language_server", {
			filetypes = {
				"css",
				"eruby",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"pug",
				"typescriptreact",
			},
			init_options = {
				showAbbreviationSuggestions = true,
				showExpandedAbbreviation = "always",
				showSuggestionsAsSnippets = false,
			},
		})
		vim.lsp.enable("emmet_language_server")

		-- Emmet LS Setup
		vim.lsp.config("emmet_ls", {
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
		})
		vim.lsp.enable("emmet_ls")

		-- TypeScript (ts_ls) Setup Configuration
		vim.lsp.config("ts_ls", {
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			single_file_support = true,
			init_options = {
				preferences = {
					includeCompletionsForModuleExports = true,
					includeCompletionsForImportStatements = true,
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			on_attach = function(client, bufnr)
				-- Stop ts_ls structural diagnostics and completions to prevent system duplications with tsc
				client.server_capabilities.diagnosticProvider = nil
				client.server_capabilities.completionProvider = nil
			end,
		})
		vim.lsp.enable("ts_ls")

		vim.lsp.config("gopls", {
			settings = {
				gopls = {
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						ignoredError = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		})

		vim.lsp.enable("gopls")

		vim.lsp.config("mermaid", {
			cmd = { "mermaid-language-server", "--stdio" },
			filetypes = { "mermaid" },
			root_markers = { ".git" },
		})

		vim.lsp.enable("mermaid")
		-- vim.lsp.config("yamlls", {
		-- 	settings = {
		-- 		yaml = {
		-- 			format = { enable = true },
		-- 			validate = true,
		-- 			schemaStore = { enable = false, url = "" },
		-- 			schemas = {
		-- 				["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.0/schema.yaml"] = {
		-- 					"/*/openapi.yaml",
		-- 					"/*/openapi.yml",
		-- 					"/openapi.yaml",
		-- 					"/openapi.yml",
		-- 				},
		-- 			},
		-- 		},
		-- 	},
		-- })
		--
		-- vim.lsp.enable("yamlls")
		--
		-- Keymaps
		vim.api.nvim_create_user_command("ToggleInlayHints", function()
			local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
			vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = 0 })

			-- Optional: Print a status message so you know it worked
			local status = not is_enabled and "Enabled" or "Disabled"
			vim.notify("Inlay hints " .. status, vim.log.levels.INFO)
		end, { desc = "Toggle LSP inlay hints for the current buffer" })

		-- local opts = {}
		-- opts.desc = "Show LSP references"
		-- vim.keymap.set("n", "gR", "<cmd>FzfLua lsp_references<CR>", opts)
		--
		-- opts.desc = "Go to declaration"
		-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		--
		-- opts.desc = "Show LSP definitions"
		-- vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", opts)
		--
		-- opts.desc = "Show LSP implementations"
		-- vim.keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", opts)
		--
		-- opts.desc = "Show LSP type definitions"
		-- vim.keymap.set("n", "gt", "<cmd>FzfLua lsp_type_definitions<CR>", opts)
		--
		-- opts.desc = "See available code actions"
		-- vim.keymap.set({ "n", "v" }, "<leader>vca", vim.lsp.buf.code_action, opts)
		--
		-- opts.desc = "Smart rename"
		-- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		--
		-- opts.desc = "Show buffer diagnostics"
		-- vim.keymap.set("n", "<leader>D", "<cmd>FzfLua diagnostics_document<CR>", opts)
		--
		-- opts.desc = "Show line diagnostics"
		-- vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
		--
		-- opts.desc = "Show documentation for what is under cursor"
		-- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		--
		-- opts.desc = "Restart LSP"
		-- vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
		--
		-- opts.desc = "Lsp signature help"
		-- vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
		--
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings
				local opts = { buffer = ev.buf, silent = true }

				-- setup inlay_hints
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client and client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
				end
				-- Keymaps
				opts.desc = "Show LSP references"
				vim.keymap.set("n", "gR", "<cmd>FzfLua lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				vim.keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", opts)
				--
				-- opts.desc = "Show LSP type definitions"
				-- vim.keymap.set("n", "gt", "<cmd>FzfLua lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>vca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				vim.keymap.set("n", "<leader>D", "<cmd>FzfLua diagnostics_document<CR>", opts)

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

				opts.desc = "Lsp signature help"
				vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
			end,
		})
	end,
}
