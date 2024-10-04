return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { focus = true },
    cmd  = "Trouble",
    keys = {
        { "<leader>Tw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
        { "<leader>To", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble workspace diagnostics for current buffer" },
        { "<leader>Tq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
        { "<leader>Tl", "cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
    }
}
