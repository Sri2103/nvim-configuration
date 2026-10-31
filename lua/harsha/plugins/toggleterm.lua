return {
    "akinsho/toggleterm.nvim",
    version = "*",
    -- Lazy loads on either the terminal toggle key or your lazygit keybind
    keys = { [[<C-\>]], "<leader>g" },
    config = function()
        local toggleterm = require("toggleterm")

        toggleterm.setup({
            size = 20,
            open_mapping = [[<C-\>]], -- Press Ctrl+\ for your regular floating terminal
            hide_numbers = true,
            shade_terminals = true,
            direction = "float",
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = {
                border = "curved",
                winblend = 3,
            },
        })

        -- Simple navigation mappings when inside regular terminal windows
        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            -- Esc to enter Normal mode in terminal
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
            vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], opts)
            vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], opts)
            vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
            vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], opts)
        end

        -- Apply navigation maps automatically to standard terminals
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

        -- =====================================================================
        -- LAZYGIT INTEGRATION
        -- =====================================================================
        local Terminal = require('toggleterm.terminal').Terminal

        local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            direction = "float",
            float_opts = {
                border = "curved",
            },
            -- Highlights clean up: keeps lazygit rendering flawlessly
            on_open = function(term)
                vim.cmd("startinsert!")
                -- Disable the generic escape mapping inside lazygit so
                -- hitting Esc goes back in git menus instead of exiting terminal insert mode
                vim.keymap.set('t', '<esc>', '<esc>', { silent = true, buffer = term.bufnr })
            end,
        })

        -- Custom function to toggle lazygit cleanly
        local function _lazygit_toggle()
            lazygit:toggle()
        end

        -- Keybind to open Lazygit panel: Space + g
        vim.keymap.set("n", "<leader>g", _lazygit_toggle, { desc = "Toggle Lazygit Floating Window", silent = true })
    end,
}
