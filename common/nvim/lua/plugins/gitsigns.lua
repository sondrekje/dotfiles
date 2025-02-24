return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/editor.lua#L126
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    on_attach = function(bufnr)
      local gitsigns = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      map("n", "<leader>ghd", gitsigns.diffthis, "Gitsigns - diff this")
      map("n", "<leader>ghD", function()
        gitsigns.diffthis("~")
      end, "Gitsigns - diff this")
      map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, "Gitsigns - toggle current line blame")
      map("n", "<leader>ghb", function()
        gitsigns.blame_line({ full = true })
      end, "Gitsigns - line blame full")
    end,
  },
  config = function()
    require("gitsigns").setup({
      current_line_blame = true,
    })
  end,
}
