return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_lsp = {},
      },
    },
    init = function()
      local group = vim.api.nvim_create_augroup("KotlinDecompile", { clear = true })

      for _, protocol in ipairs({ "jar", "jrt" }) do
        vim.api.nvim_create_autocmd("BufReadCmd", {
          group = group,
          pattern = protocol .. "://*",
          callback = function(args)
            local buf = vim.api.nvim_get_current_buf()

            vim.bo[buf].modifiable = true
            vim.bo[buf].swapfile = false
            vim.bo[buf].buftype = "nofile"

            local client = vim.iter(vim.lsp.get_clients({ name = "kotlin_lsp" })):next()
            assert(client, "No kotlin_lsp client")

            local done = false

            client:request("workspace/executeCommand", {
              command = "decompile",
              arguments = { args.match },
            }, function(err, result)
              done = true

              assert(not err, vim.inspect(err))
              assert(result and result.code, "No code returned")

              vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result.code, "\n", { plain = true }))

              vim.bo[buf].filetype = result.language:lower()
              vim.bo[buf].modifiable = false
            end)

            vim.wait(3000, function()
              return done
            end)
          end,
        })
      end
    end,
  },
}
