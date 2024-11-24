return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/lazydev.nvim",                  ft = "lua",   opts = {} },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")

        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf, silent = true }

                opts.desc = "Goto declaration"
                -- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.declaration, opts) -- goto declaration
                -- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.type_definition, opts) -- goto type definition
                opts.desc = "Peek definition(s)"
                vim.keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_definitions<CR>", opts)      -- peek definitions
                opts.desc = "Show references via Telescope"
                vim.keymap.set("n", "<leader>gu", "<cmd>Telescope lsp_references<CR>", opts)       -- peek referenc
                opts.desc = "Goto implementation"
                vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)                -- goto implementation
                opts.desc = "Goto type definiton"
                vim.keymap.set("n", "<leader>go", vim.lsp.buf.type_definition, opts)               -- goto type definition
                opts.desc = "Search symbols via Telescope"
                vim.keymap.set("n", "<leader>fd", "<cmd>Telescope lsp_document_symbols<CR>", opts) -- symbol search

                -- Info and documentation
                opts.desc = "Show hover info"
                vim.keymap.set("n", "<leader>gh", vim.lsp.buf.hover, opts)          -- hover
                vim.keymap.set("v", "<leader>gh", vim.lsp.buf.hover, opts)          -- hover (visual)
                opts.desc = "Open diagnostics popup"
                vim.keymap.set("n", "<leader>ge", vim.diagnostic.open_float, opts)  -- diagnostic popup
                opts.desc = "Show signature help"
                vim.keymap.set("n", "<leader>gp", vim.lsp.buf.signature_help, opts) -- show signature

                -- Symbols and actions
                opts.desc = "Show document symbols"
                vim.keymap.set("n", "<leader>gs", vim.lsp.buf.document_symbol, opts)      -- document symbols
                opts.desc = "Show available code actions"
                vim.keymap.set({ "v", "n" }, "<leader>ga", vim.lsp.buf.code_action, opts) -- code actions
                opts.desc = "Rename symbol"
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)               -- rename symbol
                vim.keymap.set("n", "<leader>e", vim.diagnostic.goto_next, opts)          -- next diagnostic
                vim.keymap.set("n", "<leader>E", vim.diagnostic.goto_prev, opts)          -- previous diagnostic
                opts.desc = "Show diagnostics"
                vim.keymap.set("n", "<leader>le", vim.diagnostic.show, opts)              -- show diagnostics
                opts.desc = "Highlight"
                vim.keymap.set("n", "<leader>hl", vim.lsp.buf.document_highlight, opts)   -- highlight
                opts.desc = "Clear highlights"
                vim.keymap.set("n", "<leader>hlc", vim.lsp.buf.clear_references, opts)    -- clear highlights
                opts.desc = "Run codelens if available"
                vim.keymap.set("n", "<leader>lsL", vim.lsp.codelens.run, opts)            -- run codelens if available
            end,
        })

        --local capabilities = cmp_nvim_lsp.default_capabilities()
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_nvim_lsp.default_capabilities()
        )

        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        mason_lspconfig.setup_handlers({
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end,
            ["lua_ls"] = function()
                -- configure lua server (with special settings)
                lspconfig["lua_ls"].setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            -- make the language server recognize "vim" global
                            diagnostics = {
                                globals = { "vim" },
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                })
            end,
        })
    end,
}
