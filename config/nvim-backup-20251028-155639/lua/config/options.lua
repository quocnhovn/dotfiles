-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Basic editor settings
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.colorcolumn = "80"

-- File handling
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.local/share/nvim/undo")

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Visual settings
opt.termguicolors = true
opt.cursorline = true
opt.showmode = false

-- Clipboard
opt.clipboard = "unnamedplus"

-- Completion settings
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

-- Split behavior
opt.splitright = true
opt.splitbelow = true

-- Timing settings
opt.updatetime = 200
opt.timeoutlen = 300

-- Language-specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "php" },
  callback = function()
    opt.tabstop = 4
    opt.shiftwidth = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go" },
  callback = function()
    opt.tabstop = 4
    opt.shiftwidth = 4
    opt.expandtab = false
  end,
})

-- Performance improvements
opt.lazyredraw = true
opt.synmaxcol = 240

-- Better diff
opt.diffopt:append("linematch:60")
