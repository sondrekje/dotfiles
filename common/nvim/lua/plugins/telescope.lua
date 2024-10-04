return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      "BurntSushi/ripgrep",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")

      local trouble_telescope = require("trouble.sources.telescope")

      telescope.setup({
        defaults = {
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-a>"] = function()
                vim.api.nvim_input('<Home>')
              end,
              ["<C-e>"] = function()
                vim.api.nvim_input('<End>')
              end,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-t>"] = trouble_telescope.open,
            },
          },
        },
      })

      telescope.load_extension("fzf")

      vim.keymap.set("n", "<leader>rg", builtin.live_grep, { desc = "Find files - live ripgrep" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find in buffers" })
      vim.keymap.set("n", "<leader>fc", builtin.git_status, { desc = "Find in changed files" })
      vim.keymap.set("n", "<leader>fl", builtin.current_buffer_fuzzy_find, { desc = "Find in current buffer" })
      vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Find in marks" })
      vim.keymap.set("n", "<leader>fh", builtin.command_history, { desc = "Find in command history" })
    end,
  }
}
