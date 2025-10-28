-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Better paste
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Development-specific keymaps
map("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "Format code" })
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code actions" })
map("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename symbol" })

-- Git keymaps (if using LazyGit extra)
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

-- Terminal mappings
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- Toggle options
map("n", "<leader>uf", require("lazyvim.util").format.toggle, { desc = "Toggle format on Save" })
map("n", "<leader>us", function() require("lazyvim.util").toggle("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function() require("lazyvim.util").toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ul", function() require("lazyvim.util").toggle_number() end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", require("lazyvim.util").toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function() require("lazyvim.util").toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })

-- Yazi file manager integration (if available)
map("n", "<leader>e", "<cmd>Yazi<cr>", { desc = "Open Yazi" })

-- Laravel Artisan shortcuts (PHP projects)
map("n", "<leader>la", "<cmd>terminal php artisan<cr>", { desc = "Laravel Artisan" })
map("n", "<leader>lm", "<cmd>terminal php artisan make:", { desc = "Laravel Make" })
map("n", "<leader>lt", "<cmd>terminal php artisan test<cr>", { desc = "Laravel Test" })

-- Go-specific shortcuts
map("n", "<leader>gr", "<cmd>terminal go run .<cr>", { desc = "Go Run" })
map("n", "<leader>gt", "<cmd>terminal go test<cr>", { desc = "Go Test" })
map("n", "<leader>gb", "<cmd>terminal go build<cr>", { desc = "Go Build" })

-- Docker shortcuts
map("n", "<leader>dc", "<cmd>terminal docker-compose up<cr>", { desc = "Docker Compose Up" })
map("n", "<leader>dd", "<cmd>terminal docker-compose down<cr>", { desc = "Docker Compose Down" })
