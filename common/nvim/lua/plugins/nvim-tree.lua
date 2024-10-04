return {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local nvimtree = require("nvim-tree")

        -- recommended from nvim-tree docs
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        nvimtree.setup({
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
                indent_markers = {
                    enable = true,
                },
                highlight_diagnostics = true,
                highlight_opened_files = "name",
                icons = {
                    glyphs = {
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                        },
                    },
                },
            },
            actions = {
                open_file = {
                    window_picker = { enable = false },
                },
            },
            filters = {
                dotfiles = true,
            },
            diagnostics = {
                enable = true,
                show_on_dirs = false,
                icons = {
                    hint = "󰠠",
                    info = "",
                    warning = "",
                    error = "",
                },
            },
        })

        vim.keymap.set("n", "<leader>nn", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle ntree" })
        vim.keymap.set("n", "<leader>nf", "<cmd>NvimTreeFindFile<CR>", { desc = "Open file in nvim tree" })
        vim.keymap.set("n", "<leader>nr", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh nvim tree" })
    end
}
