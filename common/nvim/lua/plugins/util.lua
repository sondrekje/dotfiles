-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/util.lua
-- Terminal Mappings
local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
      vim.cmd.wincmd(dir)
    end)
  end
end

return {
  {
    "snacks.nvim",
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      terminal = {
        win = {
          keys = {
            nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
            nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
            nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
            nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
          },
        },
      },
    },
    keys = {
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
      },
      {
        "<leader>dps",
        function()
          Snacks.profiler.scratch()
        end,
        desc = "Profiler Scratch Buffer",
      },
      {
        "<leader>cl",
        function()
          Snacks.picker.lsp_config()
        end,
        desc = "Lsp Config",
      },
    },
  },

  -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/util.lua#L38
  -- Session management. This saves your session in the background,
  -- keeping track of open buffers, window arrangement, and more.
  -- You can restore sessions when returning through the dashboard.
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
        -- stylua: ignore
        keys = {
            { "<leader>qs", function()                       	require("persistence").load()
end,                desc = "Restore Session" },
            { "<leader>qS", function()                       	require("persistence").select()
end,              desc = "Select Session" },
            { "<leader>ql", function()                       	require("persistence").load({ last = true })
end, desc = "Restore Last Session" },
            { "<leader>qd", function()                       	require("persistence").stop()
end,                desc = "Don't Save Current Session" },
        },
  },

  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
}
