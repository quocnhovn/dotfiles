-- LazyVim bootstrap and configuration
-- Enhanced for PHP, Go, Vue.js fullstack development

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Import LazyVim and its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Import our custom plugin configs
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
  },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
    end,
  },

  -- Telescope FZF extension
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make"
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "query",
          "php", "go", "javascript", "typescript", "vue",
          "html", "css", "json", "yaml", "toml",
          "bash", "dockerfile", "sql"
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true
        },
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "j-hui/fidget.nvim",
    },
    config = function()
      local cmp = require('cmp')
      local cmp_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_lsp.default_capabilities())

      require("fidget").setup({})
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "gopls",
          "intelephense", -- PHP
          "tsserver",     -- JavaScript/TypeScript
          "volar",        -- Vue.js
          "html",
          "cssls",
          "tailwindcss",
          "jsonls",
          "yamlls",
        },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup {
              capabilities = capabilities
            }
          end,

          ["lua_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup {
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                  }
                }
              }
            }
          end,

          ["gopls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.gopls.setup {
              capabilities = capabilities,
              settings = {
                gopls = {
                  analyses = {
                    unusedparams = true,
                  },
                  staticcheck = true,
                  gofumpt = true,
                },
              },
            }
          end,

          ["intelephense"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.intelephense.setup {
              capabilities = capabilities,
              settings = {
                intelephense = {
                  files = {
                    maxSize = 1000000,
                  },
                  format = {
                    braces = "allman",
                  },
                },
              },
            }
          end,
        }
      })

      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })

      vim.diagnostic.config({
        update_in_insert = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
    end
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup()
    end
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'tokyonight'
        }
      }
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end
  },

  -- Comment plugin
  {
    "numToStr/Comment.nvim",
    config = function()
      require('Comment').setup()
    end
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end
  },

  -- Which key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      require("which-key").setup()
    end
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup{
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
      }
    end
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          php = { "pint", "php_cs_fixer" },
          go = { "goimports", "gofmt" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          vue = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- File manager integration (Yazi)
  {
    "mikavilpas/yazi.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
    keys = {
      {
        "<leader>-",
        function()
          require("yazi").yazi()
        end,
        desc = "Open the file manager",
      },
      {
        "<leader>cw",
        function()
          require("yazi").yazi(nil, vim.fn.getcwd())
        end,
        desc = "Open the file manager in nvim's working directory" ,
      },
    },
    opts = {
      open_for_directories = false,
    },
  },

  -- Better buffer management
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant",
          always_show_bufferline = false,
          show_buffer_close_icons = false,
          show_close_icon = false,
          color_icons = true,
        }
      })
    end,
  },

  -- Enhanced notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
        fps = 30,
        icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "",
          TRACE = "✎",
          WARN = ""
        },
        level = 2,
        minimum_width = 50,
        render = "default",
        stages = "fade_in_slide_out",
        timeout = 5000,
        top_down = true
      })
      vim.notify = require("notify")
    end,
  },

  -- Project management
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        manual_mode = false,
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "composer.json", "go.mod" },
        ignore_lsp = {},
        exclude_dirs = {},
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = 'global',
      })
    end
  },
}

-- Setup lazy.nvim
require("lazy").setup(plugins)

-- Key mappings
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- General mappings
map('n', '<leader>pv', vim.cmd.Ex)
map('n', '<leader>w', ':w<CR>')
map('n', '<leader>q', ':q<CR>')
map('n', '<leader>wq', ':wq<CR>')

-- File explorer
map('n', '<leader>e', ':NvimTreeToggle<CR>')

-- Telescope
map('n', '<leader>ff', ':Telescope find_files<CR>')
map('n', '<leader>fg', ':Telescope live_grep<CR>')
map('n', '<leader>fb', ':Telescope buffers<CR>')
map('n', '<leader>fh', ':Telescope help_tags<CR>')

-- LSP mappings
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    map('n', 'gD', vim.lsp.buf.declaration, opts)
    map('n', 'gd', vim.lsp.buf.definition, opts)
    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', 'gi', vim.lsp.buf.implementation, opts)
    map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    map('n', '<space>D', vim.lsp.buf.type_definition, opts)
    map('n', '<space>rn', vim.lsp.buf.rename, opts)
    map({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    map('n', 'gr', vim.lsp.buf.references, opts)
    map('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Git mappings
map('n', '<leader>gs', ':Gitsigns stage_hunk<CR>')
map('n', '<leader>gr', ':Gitsigns reset_hunk<CR>')
map('n', '<leader>gp', ':Gitsigns preview_hunk<CR>')
map('n', '<leader>gb', ':Gitsigns blame_line<CR>')

-- Terminal mappings
map('n', '<leader>t', ':ToggleTerm<CR>')
map('t', '<esc>', [[<C-\><C-n>]])

-- Buffer navigation
map('n', '<leader>bn', ':bnext<CR>')
map('n', '<leader>bp', ':bprev<CR>')
map('n', '<leader>bd', ':bdelete<CR>')

-- Move lines
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- Center screen when jumping
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- Paste without losing register
map('x', '<leader>p', [["_dP]])

-- Copy to system clipboard
map({'n', 'v'}, '<leader>y', [["+y]])
map('n', '<leader>Y', [["+Y]])

-- Delete without copying
map({'n', 'v'}, '<leader>d', [["_d]])

-- File type specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"php"},
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"go"},
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = false
  end,
})

-- Auto commands
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})
