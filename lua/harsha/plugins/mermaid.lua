return {
	"kevalin/mermaid.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("mermaid").setup()

		-- Install the Tree-sitter parser:
		-- :TSInstall mermaid

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "mmd",
			callback = function()
				local buf = vim.api.nvim_get_current_buf()
				vim.keymap.set("n", "<leader>mp", "<cmd>MermaidPreview<CR>", { buffer = buf, desc = "Mermaid Preview" })
				vim.keymap.set("n", "<leader>mf", "<cmd>MermaidFormat<CR>", { buffer = buf, desc = "Mermaid Format" })
				vim.keymap.set("n", "<leader>mr", "<cmd>MermaidRender<CR>", { buffer = buf, desc = "Mermaid Render" })
				vim.keymap.set(
					"n",
					"<leader>mc",
					"<cmd>MermaidCopyURL<CR>",
					{ buffer = buf, desc = "Mermaid Copy URL" }
				)
				vim.keymap.set(
					"n",
					"<leader>mx",
					"<cmd>MermaidPreviewStop<CR>",
					{ buffer = buf, desc = "Mermaid Stop Preview" }
				)
			end,
		})
	end,
}
