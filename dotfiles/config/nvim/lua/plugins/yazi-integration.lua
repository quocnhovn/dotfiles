-- Yazi file manager integration for LazyVim IDE
-- Enhanced for Deepin OS 25 development workflow

return {
  -- Disable oil.nvim to use Yazi instead
  {
    "stevearc/oil.nvim",
    enabled = false,
  },

  -- Yazi integration for Neovim
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      -- Replace the default file manager keybinding
      {
        "<leader>e",
        "<cmd>Yazi<cr>",
        desc = "Open Yazi file manager",
      },
      -- Additional keybindings for Yazi
      {
        "<leader>E",
        "<cmd>Yazi cwd<cr>",
        desc = "Open Yazi in current working directory",
      },
      -- Open Yazi in the directory of current buffer
      {
        "<leader>fe",
        function()
          require("yazi").yazi(nil, vim.fn.expand("%:p:h"))
        end,
        desc = "Open Yazi in current buffer directory",
      },
      -- Toggle Yazi with current file selected
      {
        "<leader>fy",
        function()
          require("yazi").yazi(nil, vim.fn.expand("%:p"))
        end,
        desc = "Open Yazi with current file selected",
      },
    },
    opts = {
      -- Yazi configuration for LazyVim integration
      open_for_directories = true,
      keymaps = {
        show_help = '<f1>',
        open_file_in_vertical_split = '<c-v>',
        open_file_in_horizontal_split = '<c-x>',
        open_file_in_tab = '<c-t>',
        grep_in_directory = '<c-s>',
        replace_in_directory = '<c-g>',
        cycle_open_buffers = '<tab>',
        copy_relative_path_to_selected_files = '<c-y>',
        send_to_quickfix_list = '<c-q>',
        change_working_directory = '<c-\\>',
      },
      -- Integration with other plugins
      integrations = {
        grep_in_directory = function(directory)
          -- Use Telescope for grepping
          require("telescope.builtin").live_grep({
            search_dirs = { directory },
          })
        end,
        grep_in_selected_files = function(selected_files)
          -- Use Telescope for grepping in selected files
          require("telescope.builtin").live_grep({
            search_dirs = selected_files,
          })
        end,
        replace_in_directory = function(directory)
          -- Use Spectre for replacement
          require("spectre").open({
            cwd = directory,
          })
        end,
        replace_in_selected_files = function(selected_files)
          -- Use Spectre for replacement in selected files
          require("spectre").open({
            search_paths = selected_files,
          })
        end,
      },
      -- Floating window configuration
      floating_window_scaling_factor = 0.8,
      yazi_floating_window_winblend = 0,
      yazi_floating_window_border = "rounded",

      -- Log configuration
      log_level = vim.log.levels.OFF,

      -- Use Yazi config from our dotfiles
      use_ya_for_events_reading = true,
      use_yazi_client_id_flag = true,

      -- Highlight groups for better integration
      highlight_groups = {
        hovered_buffer = {
          fg = "#8be9fd",
          bg = "#44475a",
        },
      },
    },
    config = function(_, opts)
      require("yazi").setup(opts)

      -- Auto command to use Yazi for directory opening
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("YaziDirectoryOpening", { clear = true }),
        callback = function()
          local arg = vim.fn.argv(0)
          if arg and vim.fn.isdirectory(arg) == 1 then
            vim.defer_fn(function()
              require("yazi").yazi(nil, arg)
            end, 10)
          end
        end,
      })
    end,
  },

  -- Update Neo-tree configuration to work alongside Yazi
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      -- Keep Neo-tree for project structure viewing
      window = {
        position = "right", -- Move to right to not conflict with Yazi
        width = 35,
      },
      filesystem = {
        hijack_netrw_behavior = "disabled", -- Let Yazi handle file management
      },
    },
    keys = {
      -- Use different keybinding for Neo-tree
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer Neo-tree (cwd)",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer explorer",
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git explorer",
      },
      -- Remove the default <leader>e keybinding from Neo-tree
      { "<leader>e", false },
      { "<leader>E", false },
    },
  },

  -- Update Which-key mappings for better discoverability
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>f", group = "File/Find" },
        { "<leader>fe", desc = "Yazi (current buffer dir)" },
        { "<leader>fy", desc = "Yazi (current file selected)" },
        { "<leader>e", desc = "Yazi file manager" },
        { "<leader>E", desc = "Yazi (cwd)" },
      },
    },
  },

  -- Enhanced telescope integration for Yazi workflow
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- Additional telescope mappings that work well with Yazi
      {
        "<leader>fr",
        function()
          require("telescope.builtin").oldfiles({
            cwd_only = true,
          })
        end,
        desc = "Recent files (cwd)",
      },
      {
        "<leader>fR",
        function()
          require("telescope.builtin").oldfiles()
        end,
        desc = "Recent files (all)",
      },
    },
  },
}
