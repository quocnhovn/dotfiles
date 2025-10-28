-- Colorscheme configuration optimized for Deepin OS
-- Enhanced for eye comfort during long coding sessions

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
      transparent = false, -- Enable this to disable setting the background color
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
      styles = {
        -- Style to be applied to different syntax groups
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
      },
      sidebars = { "qf", "help", "neo-tree", "Trouble" }, -- Set a darker background on sidebar-like windows
      day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style
      hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead
      dim_inactive = true, -- dims inactive windows
      lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

      on_colors = function(colors)
        -- Customize colors for better visibility on Deepin OS
        colors.hint = colors.orange
        colors.error = "#ff757f"
        colors.warning = "#ffc777"
        colors.info = "#7dcfff"
        colors.border = "#1f2335"
      end,

      on_highlights = function(highlights, colors)
        -- Enhanced syntax highlighting for development
        highlights.Function = { fg = colors.blue, bold = true }
        highlights.Keyword = { fg = colors.purple, italic = true }
        highlights.String = { fg = colors.green }
        highlights.Comment = { fg = colors.dark5, italic = true }
        highlights.Type = { fg = colors.yellow }
        highlights.Constant = { fg = colors.orange }

        -- Better UI highlights
        highlights.WinSeparator = { fg = colors.border }
        highlights.FloatBorder = { fg = colors.border, bg = colors.bg_float }
        highlights.TelescopeBorder = { fg = colors.border, bg = colors.bg_float }
        highlights.TelescopeNormal = { bg = colors.bg_float }

        -- Enhanced Git signs
        highlights.GitSignsAdd = { fg = colors.green }
        highlights.GitSignsChange = { fg = colors.yellow }
        highlights.GitSignsDelete = { fg = colors.red }

        -- Better LSP highlights
        highlights.DiagnosticError = { fg = colors.error }
        highlights.DiagnosticWarn = { fg = colors.warning }
        highlights.DiagnosticInfo = { fg = colors.info }
        highlights.DiagnosticHint = { fg = colors.hint }

        -- Enhanced search highlights
        highlights.Search = { bg = colors.bg_search, fg = colors.fg }
        highlights.IncSearch = { bg = colors.orange, fg = colors.bg }

        -- Better cursor line
        highlights.CursorLine = { bg = colors.bg_highlight }
        highlights.CursorLineNr = { fg = colors.orange, bold = true }

        -- Enhanced fold highlights
        highlights.Folded = { fg = colors.blue, bg = colors.bg_dark }
        highlights.FoldColumn = { fg = colors.comment }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- Alternative colorscheme for variety
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = { "bold" },
        keywords = { "italic" },
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = { "bold" },
        operators = {},
      },
      color_overrides = {},
      custom_highlights = function(colors)
        return {
          -- Enhanced highlights for development
          Function = { fg = colors.blue, style = { "bold" } },
          Keyword = { fg = colors.mauve, style = { "italic" } },
          Type = { fg = colors.yellow, style = { "bold" } },
          Comment = { fg = colors.overlay1, style = { "italic" } },

          -- Better UI
          WinSeparator = { fg = colors.surface0 },
          FloatBorder = { fg = colors.surface0, bg = colors.base },

          -- Enhanced LSP
          DiagnosticError = { fg = colors.red },
          DiagnosticWarn = { fg = colors.yellow },
          DiagnosticInfo = { fg = colors.sky },
          DiagnosticHint = { fg = colors.teal },

          -- Better cursor
          CursorLine = { bg = colors.surface0 },
          CursorLineNr = { fg = colors.peach, style = { "bold" } },
        }
      end,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        telescope = {
          enabled = true,
        },
        neo_tree = {
          enabled = true,
        },
        which_key = true,
        mason = true,
        dap = {
          enabled = true,
          enable_ui = true,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
      },
    },
  },

  -- Dark theme for late night coding
  {
    "Mofiqul/dracula.nvim",
    lazy = true,
    opts = {
      colors = {},
      show_end_of_buffer = true,
      transparent_bg = false,
      lualine_bg_color = "#44475a",
      italic_comment = true,
      overrides = {
        -- Enhanced highlights for better development experience
        Function = { fg = "#50fa7b", bold = true },
        Keyword = { fg = "#ff79c6", italic = true },
        Type = { fg = "#8be9fd", bold = true },
        String = { fg = "#f1fa8c" },
        Comment = { fg = "#6272a4", italic = true },

        -- Better UI elements
        WinSeparator = { fg = "#44475a" },
        FloatBorder = { fg = "#6272a4", bg = "#282a36" },

        -- Enhanced cursor and search
        CursorLine = { bg = "#44475a" },
        CursorLineNr = { fg = "#ffb86c", bold = true },
        Search = { bg = "#ffb86c", fg = "#282a36" },
        IncSearch = { bg = "#ff5555", fg = "#f8f8f2" },

        -- Better diagnostic highlights
        DiagnosticError = { fg = "#ff5555" },
        DiagnosticWarn = { fg = "#ffb86c" },
        DiagnosticInfo = { fg = "#8be9fd" },
        DiagnosticHint = { fg = "#50fa7b" },
      },
    },
  },
}
