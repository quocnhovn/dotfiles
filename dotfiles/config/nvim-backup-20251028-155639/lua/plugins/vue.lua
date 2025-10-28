-- Enhanced Vue.js and frontend development support
return {
  -- Vue Language Features (Volar)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        volar = {
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
        },
      },
    },
  },

  -- Vue syntax highlighting
  {
    "posva/vim-vue",
    ft = "vue",
  },

  -- Emmet support
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "vue", "jsx", "tsx" },
    config = function()
      vim.g.user_emmet_leader_key = '<C-Z>'
      vim.g.user_emmet_settings = {
        vue = {
          extends = 'html',
        },
      }
    end,
  },

  -- Tailwind CSS support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  "tw`([^`]*)",
                  "tw=\"([^\"]*)",
                  "tw={'([^'}]*)",
                  "tw\\.\\w+`([^`]*)",
                  "tw\\(.*?\\)`([^`]*)",
                },
              },
            },
          },
        },
      },
    },
  },

  -- Auto tag closing
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "vue", "jsx", "tsx" },
    config = function()
      require("nvim-ts-autotag").setup({
        filetypes = { "html", "xml", "vue", "jsx", "tsx" },
      })
    end,
  },

  -- ESLint integration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          settings = {
            workingDirectory = { mode = "auto" },
          },
        },
      },
    },
  },

  -- Prettier formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
    },
  },

  -- Package.json support
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    ft = "json",
    config = function()
      require("package-info").setup()
    end,
  },

  -- Treesitter support for frontend languages
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "vue",
        "javascript",
        "typescript",
        "tsx",
        "css",
        "scss",
        "html",
      })
    end,
  },
}
