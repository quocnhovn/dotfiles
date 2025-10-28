-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Enhanced for Deepin OS 25 and LG laptop optimization

-- Enable spell check by default unless in vscode
if not vim.g.vscode then
  vim.o.spell = true
end

-- Set conceal level to 0 for better readability
vim.o.conceallevel = 0

-- Performance optimizations for laptop
vim.opt.updatetime = 250  -- Faster completion
vim.opt.timeoutlen = 300  -- Faster which-key
vim.opt.ttimeoutlen = 10  -- Faster escape sequence
vim.opt.lazyredraw = true -- Don't redraw screen during macros

-- Better scrolling experience
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.smoothscroll = true

-- Enhanced editor settings for development
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.showbreak = "↳ "

-- Better search experience
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Enhanced clipboard for system integration
vim.opt.clipboard = "unnamedplus"

-- Better backup and undo
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Deepin OS specific optimizations
vim.opt.mouse = "a"  -- Enable mouse support
vim.opt.mousemodel = "popup"  -- Right-click context menu

-- File encoding for international projects
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Disable providers for better startup time
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Setup options for development environment
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- LSP specific optimizations
vim.opt.signcolumn = "yes:2"  -- Always show sign column with space for multiple signs
vim.opt.colorcolumn = "80,120"  -- Visual guides for code width

-- Better completion experience
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10  -- Limit popup menu height

-- Terminal colors and GUI options
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Session options for better project restoration
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Fold settings for code navigation
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Indentation for different file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "php", "javascript", "typescript", "vue", "json" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false  -- Go uses tabs
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "css", "scss", "sass" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- Auto-save functionality for better development workflow
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      vim.api.nvim_command("silent update")
    end
  end,
})
end
