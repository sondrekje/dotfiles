return {
  "barrett-ruth/import-cost.nvim",
  init = function()
    vim.g.import_cost = {
      package_manager = "npm",
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
      format = {
        byte_format = "%.1fb",
        kb_format = "%.1fk",
        virtual_text = "%s (gzipped: %s)",
      },
      highlight = "Comment",
    }
  end,
}
