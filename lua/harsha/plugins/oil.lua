return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional: adds file icons
    lazy = false,                                     -- Ensures it intercepts folder paths right at launch
    config = function()
        require("oil").setup({
            default_file_explorer = true,
            columns = {
                "icon",
            },
            view_options = {
                show_hidden = true, -- show hidden files like .env or .gitignore
            },
        })

        vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open parent directory" })
    end,
}
