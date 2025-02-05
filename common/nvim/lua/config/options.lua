vim.cmd("let g:netrw_liststyle = 3")

vim.opt.number = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true -- spaces instead oftabs
vim.opt.autoindent = true

vim.opt.cursorline = true

vim.opt.wrap = true

vim.opt.showmatch = true

vim.opt.incsearch = true
vim.opt.smartcase = true

vim.opt.scrolloff = 3

vim.opt.ruler = true

vim.cmd('syntax enable')

vim.opt.encoding = 'utf-8'

vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.keymap.set("n", "Q", "gq")

vim.opt.mouse = "a"
vim.opt.foldlevel = 99
vim.opt.list = true -- show some invisible characters
vim.opt.shiftround = true
vim.opt.showmode = false

vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time

vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"

vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.smoothscroll = true
vim.opt.foldmethod = "indent"

local yank_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = 'Visual',
      timeout = 300,
    })
  end,
})

