-- Custom configuration for Deepin OS 25 Development Environment
-- Optimized for PHP (Laravel/CodeIgniter/Symfony), Go, Vue.js fullstack development

return {
  -- Deepin OS specific configurations
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- PHP Language Server (Intelephense)
        intelephense = {
          settings = {
            intelephense = {
              files = {
                maxSize = 5000000,
              },
            },
          },
        },

        -- Go Language Server
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },

        -- Vue Language Server
        volar = {
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
        },

        -- HTML/CSS for web development
        html = {},
        cssls = {},

        -- Docker support
        dockerls = {},
        docker_compose_language_service = {},

        -- JSON/YAML
        jsonls = {},
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/composer.json"] = "composer.json",
                ["https://json.schemastore.org/package.json"] = "package.json",
              },
            },
          },
        },
      },
    },
  },

  -- Enhanced file management for projects
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            "node_modules",
            "vendor",
            ".git",
            ".DS_Store",
            "thumbs.db",
          },
        },
        follow_current_file = {
          enabled = true,
        },
      },
    },
  },

  -- Git integration optimized for team development
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 300,
      },
    },
  },

  -- Enhanced terminal for development workflow
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
      { "<leader>tt", "<cmd>ToggleTerm direction=tab<cr>", desc = "Terminal Tab" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal Horizontal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Terminal Vertical" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return 80
        end
      end,
      open_mapping = [[<C-\>]],
      shade_terminals = true,
      start_in_insert = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = "/usr/bin/fish", -- Use Fish shell
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      -- Setup Yazi integration
      require("config.yazi-config").setup()
    end,
  },

  -- Enhanced autocomplete for web development
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-calc",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "emoji" },
        { name = "calc" },
      }))
    end,
  },

  -- Enhanced debugging for multiple languages
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      -- PHP debugging
      "xdebug/vscode-php-debug",
      -- Go debugging
      "leoluz/nvim-dap-go",
      -- Node.js debugging
      "microsoft/vscode-js-debug",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup DAP UI
      dapui.setup()

      -- PHP debugging configuration
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { "/path/to/vscode-php-debug/out/phpDebug.js" },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
          log = true,
          pathMappings = {
            ["/var/www/html"] = "${workspaceFolder}",
          },
        },
      }

      -- Go debugging
      require("dap-go").setup()

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug Conditional Breakpoint" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug REPL" },
    },
  },

  -- Project-specific environment variables
  {
    "tpope/vim-dotenv",
    event = "VeryLazy",
  },

  -- Enhanced status line for development info
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Add Git branch and diff stats
      table.insert(opts.sections.lualine_b, {
        "diff",
        symbols = { added = " ", modified = " ", removed = " " },
      })

      -- Add file encoding and format
      table.insert(opts.sections.lualine_y, "encoding")
      table.insert(opts.sections.lualine_y, "fileformat")

      -- Add LSP status
      table.insert(opts.sections.lualine_x, {
        function()
          local clients = vim.lsp.get_active_clients({ bufnr = 0 })
          if #clients == 0 then
            return "No LSP"
          end
          local names = {}
          for _, client in ipairs(clients) do
            table.insert(names, client.name)
          end
          return "LSP: " .. table.concat(names, ", ")
        end,
        icon = " ",
      })

      return opts
    end,
  },
}
