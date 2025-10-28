-- Yazi File Manager Configuration for Deepin OS
-- Integrates with LazyVim while maintaining dotfiles consistency

local M = {}

-- Configure Yazi paths and settings
local function setup_yazi_paths()
  -- Use global Yazi config from dotfiles
  local yazi_config_dir = vim.fn.expand("~/.config/yazi")

  -- Ensure Yazi config exists
  if vim.fn.isdirectory(yazi_config_dir) == 0 then
    vim.notify("Yazi config directory not found. Please run the main dotfiles install script.", vim.log.levels.WARN)
  end
end

-- Setup Yazi keybindings consistent with dotfiles
local function setup_yazi_keybindings()
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- Main file manager keybinding (replaces oil.nvim)
  map("n", "<leader>e", function()
    require("yazi").yazi()
  end, { desc = "Open Yazi file manager" })

  -- Alternative file manager keybinding
  map("n", "<leader>E", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neo-tree" })

  -- Yazi in current directory
  map("n", "<leader>fy", function()
    require("yazi").yazi(nil, vim.fn.getcwd())
  end, { desc = "Open Yazi in current working directory" })

  -- Yazi with current file selected
  map("n", "<leader>fY", function()
    require("yazi").yazi(nil, vim.fn.expand("%:p:h"), vim.fn.expand("%:p"))
  end, { desc = "Open Yazi with current file selected" })
end

-- Setup Yazi integrations with LazyVim ecosystem
local function setup_yazi_integrations()
  -- Integration with telescope for file preview
  local function open_with_telescope()
    require("yazi").yazi(nil, nil, function(chosen_file)
      if chosen_file then
        require("telescope.builtin").find_files({
          default_text = vim.fn.fnamemodify(chosen_file, ":t"),
          cwd = vim.fn.fnamemodify(chosen_file, ":h"),
        })
      end
    end)
  end

  vim.keymap.set("n", "<leader>ft", open_with_telescope, { desc = "Yazi + Telescope" })

  -- Integration with spectre for search and replace
  local function open_with_spectre()
    require("yazi").yazi(nil, nil, function(chosen_file)
      if chosen_file then
        local spectre = require("spectre")
        spectre.toggle({
          cwd = vim.fn.fnamemodify(chosen_file, ":h"),
        })
      end
    end)
  end

  vim.keymap.set("n", "<leader>fs", open_with_spectre, { desc = "Yazi + Spectre" })
end

-- Main setup function
function M.setup()
  setup_yazi_paths()
  setup_yazi_keybindings()
  setup_yazi_integrations()

  -- Setup autocmds for better integration
  local augroup = vim.api.nvim_create_augroup("YaziIntegration", { clear = true })

  -- Auto-refresh neo-tree when Yazi makes changes
  vim.api.nvim_create_autocmd("User", {
    group = augroup,
    pattern = "YaziDirChanged",
    callback = function()
      -- Refresh neo-tree if it's open
      local neotree = require("neo-tree.command")
      if neotree then
        neotree.execute({ action = "refresh" })
      end
    end,
  })

  -- Better terminal integration for Yazi
  vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    pattern = "*",
    callback = function()
      if vim.bo.filetype == "yazi" then
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
      end
    end,
  })
end

return M
