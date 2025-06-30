local icons = { Error = " ", Warn = " ", Info = " ", Hint = "󰠠 " }

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim" },
      { "mason-org/mason-lspconfig.nvim" },
      { "folke/lazydev.nvim", ft = "lua", opts = {} },
      -- { "antosha418/nvim-lsp-file-operations", config = true },
    },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = icons.Error,
              [vim.diagnostic.severity.WARN] = icons.Warn,
              [vim.diagnostic.severity.HINT] = icons.Hint,
              [vim.diagnostic.severity.INFO] = icons.Info,
            },
          },
        },
        inlay_hints = {
          enabled = true,
        },
        codelens = {
          enabled = true,
        },
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
        servers = {
          lua_ls = {
            mason = false,
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
              },
            },
          },
        },
      }
      return ret
    end,
    config = function(_, options)
      vim.diagnostic.config(vim.deepcopy(options.diagnostics))

      for name, cfg in pairs(options.servers) do
        vim.lsp.config(
          name,
          vim.tbl_deep_extend("force", {
            capabilities = vim.tbl_deep_extend(
              "force",
              {},
              vim.lsp.protocol.make_client_capabilities(),
              require("blink.cmp").get_lsp_capabilities(),
              options.capabilities or {}
            ),
          }, cfg)
        )
      end

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = options.ensure_installed or { "lua_ls" },
        automatic_enable = true,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my.lsp", {}),
        callback = function(args)
          local buf = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

          -- Inlay‐hints on attach
          if options.inlay_hints.enabled then
            local excludeFor = options.inlay_hints.exclude or {}
            if client:supports_method("textDocument/inlayHint") then
              local ft = vim.bo[buf].filetype
              if vim.bo[buf].buftype == "" and not vim.tbl_contains(excludeFor, ft) then
                vim.lsp.inlay_hint.enable(true, { bufnr = buf })
              end
            end
          end

          -- Codelens on attach
          if options.codelens.enabled then
            if client:supports_method("textDocument/codeLens") then
              vim.lsp.codelens.refresh()
              vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                buffer = buf,
                callback = vim.lsp.codelens.refresh,
              })
            end
          end

          if client:supports_method("textDocument/codeAction") then
            local bufopts = { buffer = buf, silent = true, desc = "Remove Unused Imports" }
            vim.keymap.set("n", "grU", function()
              vim.lsp.buf.code_action({
                context = {
                  diagnostics = {},
                  ---@diagnostic disable-next-line: assign-type-mismatch
                  only = { "source.removeUnusedImports" },
                },
                apply = true,
              })
            end, bufopts)
          end

          local bufopts = { buffer = buf, silent = true, desc = "Add Missing Imports" }
          vim.keymap.set("n", "grM", function()
            vim.lsp.buf.code_action({
              context = {
                diagnostics = {}, -- must include this even if empty
                only = {
                  ---@diagnostic disable-next-line: assign-type-mismatch
                  "source.addMissingImports",
                },
              },
              apply = true, -- auto-apply the single returned action
            })
          end, bufopts)
        end,
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
}
