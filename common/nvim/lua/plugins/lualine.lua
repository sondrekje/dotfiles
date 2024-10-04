return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    options = { theme = "gruvbox_dark" },
    config = function()
        local lualine = require("lualine")

        lualine.setup({
            options = { theme = "gruvbox-material" },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch' },
                lualine_c = {
                    'filename',
                    {
                        'diagnostics',
                        sources = { 'nvim_diagnostic' },
                        sections = { 'error', 'warn', 'info', 'hint' },
                        symbols = { error = ' ', warn = ' ', info = ' ', hint = '󰠠 ' },
                        colored = true,
                        update_in_insert = false,
                        always_visible = true,
                    }
                },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            tabline = {
                lualine_a = {
                    {
                        'buffers',
                        show_filename_only = true,
                        hide_filename_extension = false,
                        show_modified_status = true,
                        mode = 4, -- show buffer name + buffer number
                        symbols = {
                            modified = ' ●',
                            alternate_file = '',
                        },
                    }
                },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            }
        })
    end,
}
