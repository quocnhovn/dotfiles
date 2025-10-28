-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Language-specific autocmds

-- PHP settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("php_settings"),
  pattern = "php",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    -- Enable PHP-specific features
    vim.keymap.set("n", "<leader>pp", "<cmd>terminal php %<cr>", { buffer = true, desc = "Run PHP file" })
  end,
})

-- Go settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("go_settings"),
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = false
    -- Auto format on save for Go files
    vim.keymap.set("n", "<leader>gf", "<cmd>!gofmt -w %<cr>", { buffer = true, desc = "Format Go file" })
  end,
})

-- Vue/JavaScript settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("vue_js_settings"),
  pattern = { "vue", "javascript", "typescript" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- JSON settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("json_settings"),
  pattern = "json",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Auto-reload Fish config on save
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup("fish_reload"),
  pattern = "*/fish/config.fish",
  command = "silent !source %",
})

-- Laravel Blade syntax
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("blade_files"),
  pattern = "*.blade.php",
  command = "set filetype=blade",
})

-- Disable autoformat for certain files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("disable_autoformat"),
  pattern = { "sql", "mysql" },
  callback = function()
    vim.b.autoformat = false
  end,
})
