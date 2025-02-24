return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>Tw",
        "<cmd>Trouble diagnostics toggle<CR>",
        desc = "Workspace diagnostics (Trouble)",
      },
      { "<leader>To", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics (Trouble)" },
      { "<leader>Tq", "<cmd>Trouble quickfix toggle<CR>", desc = "Quickfix List (Trouble)" },
      { "<leader>Tl", "cmd>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" },
      { "<leader>Ts", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      {
        "<leader>TS",
        "<cmd>Trouble lsp toggle<cr>",
        desc = "LSP references/definitions/... (Trouble)",
      },
      {
        "]q",
        function()
          require("trouble").next({ skip_groups = true, jump = true })
        end,
        desc = "Next item (Trouble)",
      },
      {
        "[q",
        function()
          require("trouble").prev({ skip_groups = true, jump = true })
        end,
        desc = "Previous item (Trouble)",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next TODO comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_previous()
        end,
        desc = "Previous TODO comment",
      },
      {
        "<leader>Tt",
        "<cmd>Trouble todo toggle<CR>",
        desc = "Toggle TODO (Trouble)",
      },
      {
        "<leader>TT",
        "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<CR>",
        desc = "Toggle TODO/FIX/FIXME (Trouble)",
      },
    },
  },
}
