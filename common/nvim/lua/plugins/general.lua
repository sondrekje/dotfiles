return {
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  { "nvim-lua/plenary.nvim" },
  {
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-rhubarb",
      "tommcdo/vim-fubitive",
    },
    config = function()
      vim.g.fubitive_domain_pattern = [[git\.[^/]*\.[a-z]\{2\}]]
    end,
  },
  { "tpope/vim-repeat" },
  { "tpope/vim-unimpaired" },
  { "tpope/vim-rsi" },
  { "tpope/vim-sleuth" },
}
