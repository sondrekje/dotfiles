vim.keymap.set("n", "Q", "gq")

vim.api.nvim_set_keymap("n", "<leader>s-", ":split<CR>", { desc = "Split horizontally", noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>sH", ":split<CR>", { desc = "Split horizontally", noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>s|", ":vsplit<CR>", { desc = "Split vertically", noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>sV", ":vsplit<CR>", { desc = "Split vertically", noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>sB", "<C-w>=", { desc = "Balance split windows", noremap = true, silent = true })

-- Split navigation using Ctrl + arrow keys
-- vim.keymap.set("n", "<C-j>", "<C-W>j")
-- vim.keymap.set("n", "<C-k>", "<C-W>k")
-- vim.keymap.set("n", "<C-h>", "<C-W>h")
-- vim.keymap.set("n", "<C-l>", "<C-W>l")

-- Fast saving with Ctrl + s
vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("v", "<C-s>", "<Cmd>w<CR>")

vim.keymap.set("n", "<leader>y", '"*yy', { noremap = true, silent = true })
vim.keymap.set("v", "<leader>y", '"*y', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>p", ':set paste<CR>"*p:set nopaste<CR>') -- Paste from clipboard
vim.keymap.set("v", "<leader>p", '<Esc>:set paste<CR>gv"*p:set nopaste<CR>')
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- paste replace
vim.keymap.set("x", "<leader>p", [["_dP]])
-- delete into void register
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- Repeat last command for each line in a visual selection
vim.keymap.set("v", ".", ":normal .<CR>")

vim.keymap.set("n", "<leader>ggb", ":Git blame<CR>")
vim.keymap.set("n", "<leader>ggl", ":Git log<CR>")
vim.keymap.set("n", "<leader>ggd", ":Gdiffsplit<CR>")
vim.keymap.set("n", "<leader>ggc", ":Gcommit<CR>")

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "<leader>e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "<leader>E", diagnostic_goto(false, "ERROR"), { desc = "Previous Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Previous Error" })
vim.keymap.set("n", "<leader>w", diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
vim.keymap.set("n", "<leader>W", diagnostic_goto(false, "WARNING"), { desc = "Previous Warning" })
vim.keymap.set("n", "]w", diagnostic_goto(false, "WARNING"), { desc = "Previous Warning" })
