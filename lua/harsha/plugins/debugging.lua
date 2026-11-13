return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
			"mason-org/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			"stevearc/overseer.nvim",
			"leoluz/nvim-dap-go",
			"mfussenegger/nvim-dap-python",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- 1. Setup Mason & automatically configure installed adapters
			require("mason").setup()
			require("mason-nvim-dap").setup({
				ensure_installed = {
					"python",
					"delve",
					"codelldb",
					"js",
				},
				automatic_installation = true,
				handlers = {},
			})

			-- 2. Go setup & VS Code mapping ("go" -> "delve")
			require("dap-go").setup()
			dap.adapters.go = dap.adapters.delve

			-- 3. Python setup & VS Code mapping ("debugpy" -> "python")
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(mason_path)
			dap.adapters.debugpy = dap.adapters.python

			-- 4. JavaScript / TypeScript VS Code mappings
			for _, adapter in ipairs({ "node", "chrome", "pwa-chrome", "node-terminal" }) do
				dap.adapters[adapter] = dap.adapters["pwa-node"]
			end

			-- 5. Breakpoint & Execution Gutter Signs (Requires a Nerd Font)
			local dap_signs = {
				DapBreakpoint = { text = "●", texthl = "DiagnosticError" },
				DapBreakpointCondition = { text = "", texthl = "DiagnosticWarn" },
				DapBreakpointRejected = { text = "", texthl = "DiagnosticError" },
				DapLogPoint = { text = "", texthl = "DiagnosticInfo" },
				DapStopped = { text = "  ", texthl = "DiagnosticOk", linehl = "Visual" },
			}
			for name, sign in pairs(dap_signs) do
				vim.fn.sign_define(name, {
					text = sign.text,
					texthl = sign.texthl,
					linehl = sign.linehl or "",
					numhl = sign.texthl,
				})
			end

			-- 6. Setup DAP UI with custom Nerd Font icons
			dapui.setup({
				icons = {
					expanded = "▾",
					collapsed = "▸",
					current_frame = "▸",
				},
				controls = {
					enabled = true,
					element = "repl",
					icons = {
						pause = "",
						play = "",
						step_into = "",
						step_over = "",
						step_out = "",
						step_back = "",
						run_last = "↻",
						terminate = "□",
						disconnect = "⏏",
					},
				},
			})

			require("nvim-dap-virtual-text").setup()
			require("overseer").setup()

			-- 7. Keymaps
			vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>dC", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Conditional Breakpoint" })
			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: Step Out" })

			vim.keymap.set("n", "<leader>db", dap.list_breakpoints, { desc = "Debug: List Breakpoints" })
			vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
			vim.keymap.set("n", "<leader>dq", function()
				dap.terminate()
				dap.disconnect({ terminateDebuggee = true })
				dapui.close()
			end, { desc = "Debug: Terminate Session" })

			-- 8. Auto-open/close DAP UI
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
}
