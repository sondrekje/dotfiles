return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_lsp = {
          settings = {
            ["jetbrains.kotlin.hints.parameters"] = true,
            ["jetbrains.kotlin.hints.parameters.compiled"] = true,
            ["jetbrains.kotlin.hints.settings.types.property"] = true,
            ["jetbrains.kotlin.hints.settings.types.variable"] = true,
            ["jetbrains.kotlin.hints.type.function.return"] = true,
            ["jetbrains.kotlin.hints.type.function.parameter"] = true,
            ["jetbrains.kotlin.hints.settings.lambda.return"] = true,
            ["jetbrains.kotlin.hints.lambda.receivers.parameters"] = true,
            ["jetbrains.kotlin.hints.settings.value.ranges"] = true,
            ["jetbrains.kotlin.hints.value.kotlin.time"] = true,
          },
        },
        handlers = {
          ["workspace/configuration"] = function(_, params)
            local result = {}

            for _, item in ipairs(params.items or {}) do
              if item.section == "jetbrains.kotlin" then
                table.insert(result, {
                  hints = {
                    parameters = true,
                    ["parameters.compiled"] = true,
                    settings = {
                      types = {
                        property = true,
                        variable = true,
                      },
                      lambda = {
                        ["return"] = true,
                      },
                      value = {
                        ranges = true,
                      },
                    },
                    type = {
                      ["function"] = {
                        ["return"] = true,
                        parameter = true,
                      },
                    },
                    lambda = {
                      receivers = {
                        parameters = true,
                      },
                    },
                    value = {
                      kotlin = {
                        time = true,
                      },
                    },
                  },
                })
              else
                table.insert(result, vim.NIL)
              end
            end

            return result
          end,
        },
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
            if not client then
              vim.notify("kotlin_lsp not available for decomplation", vim.log.levels.INFO)
              return
            end

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
