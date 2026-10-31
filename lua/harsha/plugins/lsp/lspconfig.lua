return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- NOTE: LSP Keybinds
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings
				local opts = { buffer = ev.buf, silent = true }

				-- setup inlay_hints (FIXED: Uses standard method checking)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client and vim.lsp.client.supports_method(client, "textDocument/inlayHint") then
					local bufnr = ev.buf
					local inlay_hints_group =
						vim.api.nvim_create_augroup("InsertModeInlayHints_" .. bufnr, { clear = true })

					vim.lsp.inlay_hint.enable(false, { bufnr = ev.buf })

					vim.api.nvim_create_autocmd("InsertEnter", {
						group = inlay_hints_group,
						buffer = bufnr,
						callback = function()
							vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
						end,
					})

					-- Turn hints OFF when leaving Insert mode
					vim.api.nvim_create_autocmd("InsertLeave", {
						group = inlay_hints_group,
						buffer = bufnr,
						callback = function()
							vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
						end,
					})
				end

				-- Keymaps
				opts.desc = "Show LSP references"
				vim.keymap.set("n", "gR", "<cmd>fzfLua lsP_references<CR>", opts)

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gd", "<cmd>fzfLua lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				vim.keymap.set("n", "gi", "<cmd>fzfLua lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				vim.keymap.set("n", "gt", "<cmd>fzfLua lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>vca", function()
					vim.lsp.buf.code_action()
				end, opts)

				opts.desc = "Smart rename"
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				vim.keymap.set("n", "<leader>D", "<cmd>fzfLua diagnostics_document<CR>", opts)

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

				opts.desc = "Lsp signature help"
				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)
			end,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf }
				-- THE LSP FIX COMMAND: Trigger code actions/quickfixes for the current error
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
					{ desc = "LSP Code Action / Quickfix" })

				-- Jump between diagnostics natively
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })

				-- Open floating diagnostic window
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
			end,
		})

		-- Define sign icons for each severity
		local signs = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = "⚑",
		}

		-- Set diagnostic config
		vim.diagnostic.config({
			signs = {
				text = signs,
			},
			virtual_text = true,
			underline = true,
			update_in_insert = false,
		})

		-- Setup servers
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Global LSP settings (applied to all servers)
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-- Configure and enable LSP servers
		-- lua_ls
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
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

		-- emmet_language_server
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
				includeLanguages = {},
				excludeLanguages = {},
				extensionsPath = {},
				preferences = {},
				showAbbreviationSuggestions = true,
				showExpandedAbbreviation = "always",
				showSuggestionsAsSnippets = false,
				syntaxProfiles = {},
				variables = {},
			},
		})
		vim.lsp.enable("emmet_language_server")

		-- emmet_ls
		vim.lsp.config("emmet_ls", {
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
			},
		})
		vim.lsp.enable("emmet_ls")

		-- ============================================================================
		-- 1. Configuration for Native TypeScript 7 LSP (tsc)
		-- ============================================================================

		-- 	filetypes = {
		-- 		"javascript",
		-- 		"javascriptreact",
		-- 		"typescript",
		-- 		"typescriptreact",
		-- 	},
		-- 	root_markers = { "tsconfig.json", "package.json", ".git" },
		-- 	-- Force tsc to take ownership of completions and diagnostics
		-- 	-- on_attach = function(client, bufnr)
		-- 	-- 	-- Ensure tsc capabilities are active
		-- 	-- 	client.server_capabilities.completionProvider = true
		-- 	-- 	client.server_capabilities.diagnosticProvider = true
		-- 	-- end,
		-- })
		-- vim.lsp.enable("tsc")
		--
		-- ============================================================================
		-- 2. Adjusted Configuration for ts_ls (To avoid duplicate conflicts)
		-- ============================================================================

		-- 		"javascript",
		-- 		"javascriptreact",
		-- 		"typescript",
		-- 		"typescriptreact",
		-- 	},
		-- 	single_file_support = true,
		-- 	init_options = {
		-- 		tsserver = {
		-- 			path = vim.fn.expand("$USERPROFILE")
		-- 				.. "\\AppData\\Local\\nvim-data\\mason\\packages\\typescript-language-server\\node_modules\\typescript\\lib\\tsserver.js",
		-- 		},
		-- 		preferences = {
		-- 			includeCompletionsForModuleExports = true,
		-- 			includeCompletionsForImportStatements = true,
		-- 			-- Inlay options preserved from your original setup
		-- 			includeInlayParameterNameHints = "all",
		-- 			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
		-- 			includeInlayFunctionParameterTypeHints = true,
		-- 			includeInlayVariableTypeHints = true,
		-- 			includeInlayVariableTypeHintsWhenTypeMatchesName = true,
		-- 			includeInlayPropertyDeclarationTypeHints = true,
		-- 			includeInlayFunctionLikeReturnTypeHints = true,
		-- 			includeInlayEnumMemberValueHints = true,
		-- 		},
		-- 	},
		-- 	-- Reconcile capabilities on attach to prevent clashes
		-- 	on_attach = function(client, bufnr)
		-- 		-- Disable duplicate diagnostics from ts_ls (let tsc handle this)
		-- 		client.server_capabilities.diagnosticProvider = nil
		--
		-- 		-- Disable duplicate completion items to prevent lists from doubling up
		-- 		client.server_capabilities.completionProvider = nil
		--
		-- 		-- Alternatively, if you want ts_ls code actions or definitions instead,
		-- 		-- those will still work as they won't trigger active UX duplicate lists.
		-- 	end,
		-- })
		-- vim.lsp.enable("ts_ls")

		-- -- ts_ls (TypeScript/JavaScript)
		vim.lsp.config("ts_ls", {
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
			single_file_support = true,
			init_options = {
				preferences = {
					includeCompletionsForModuleExports = true,
					includeCompletionsForImportStatements = true,
					-- inlay options
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
		})
		--	vim.lsp.enable("ts_ls")
		--
		-- -- gopls
		vim.lsp.config("gopls", {
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		})
		vim.lsp.enable("gopls")

		-- basedpyright (FIXED: Added missing vim.lsp.enable command)
		vim.lsp.config("basedpyright", {
			settings = {
				basedpyright = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						typeCheckingMode = "recommended",
						diagnosticMode = "openFilesOnly",
						inlayHints = {
							callArgumentNamesMatching = true,
							callArgumentNames = true,
							variableTypes = true,
							functionReturnTypes = true,
							genericTypes = true,
						},
					},
				},
			},
		})
		vim.lsp.enable("basedpyright")

		-- bash
		vim.lsp.config("bashls", {})
		vim.lsp.enable("bashls")
		--vim.lsp.config("ruff", {})
		-- vim.lsp.enable("ruff")
	end,
}
