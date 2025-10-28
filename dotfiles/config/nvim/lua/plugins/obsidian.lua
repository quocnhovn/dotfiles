-- Obsidian.nvim plugin for note-taking and knowledge management
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp", -- for autocompletion
    "nvim-telescope/telescope.nvim", -- for search and navigation
    "nvim-treesitter/nvim-treesitter", -- for syntax highlighting
  },
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "personal",
          path = "~/notes",
        },
        {
          name = "work",
          path = "~/work-notes",
        },
      },

      -- Optional, if you keep notes in a specific subdirectory of your vault.
      notes_subdir = "notes",

      -- Daily notes configuration
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = "daily-template.md"
      },

      -- Templates configuration
      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {
          yesterday = function()
            return os.date("%Y-%m-%d", os.time() - 86400)
          end,
          tomorrow = function()
            return os.date("%Y-%m-%d", os.time() + 86400)
          end,
        },
      },

      -- Completion configuration
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },

      -- Mappings configuration
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action CR
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        }
      },

      -- Where to put new notes created from completion. Valid options are
      -- "current_dir", "notes_subdir", or "sub_dir". Default is "current_dir".
      new_notes_location = "notes_subdir",

      -- Optional, customize how note IDs are generated given an optional title.
      note_id_func = function(title)
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          local suffix = ""
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
          return tostring(os.time()) .. "-" .. suffix
        end
      end,

      -- Optional, customize how note file names are generated given the ID, title, and path.
      note_path_func = function(spec)
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,

      -- Optional, customize how wiki links are formatted.
      wiki_link_func = function(opts)
        if opts.id == nil then
          return string.format("[[%s]]", opts.label)
        elseif opts.label ~= opts.id then
          return string.format("[[%s|%s]]", opts.id, opts.label)
        else
          return string.format("[[%s]]", opts.id)
        end
      end,

      -- Optional, customize how markdown links are formatted.
      markdown_link_func = function(opts)
        return string.format("[%s](%s)", opts.label, opts.path)
      end,

      -- Either 'wiki' or 'markdown'.
      preferred_link_style = "wiki",

      -- Optional, customize the default tags or add your own.
      note_frontmatter_func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      -- Optional, for templates (see below).
      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      follow_url_func = function(url)
        vim.fn.jobstart({"open", url})  -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- Linux
      end,

      -- Optional, set to true if you use the Obsidian Advanced URI plugin.
      use_advanced_uri = false,

      -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
      open_app_foreground = false,

      picker = {
        name = "telescope.nvim",
        mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
      },

      -- Optional, sort search results by "path", "modified", "accessed", or "created".
      sort_by = "modified",
      sort_reversed = true,

      -- Optional, determines how certain commands open notes. The valid options are:
      -- 1. "current" (default) - to always open in the current window
      -- 2. "vsplit" - to open in a vertical split
      -- 3. "hsplit" - to open in a horizontal split
      open_notes_in = "current",

      -- Optional, define your own callbacks to further customize behavior.
      callbacks = {
        -- Runs at the end of `require("obsidian").setup()`.
        post_setup = function(client) end,

        -- Runs anytime you enter the buffer for a note.
        enter_note = function(client, note) end,

        -- Runs anytime you leave the buffer for a note.
        leave_note = function(client, note) end,

        -- Runs right before writing the buffer for a note.
        pre_write_note = function(client, note) end,

        -- Runs anytime the workspace is set/changed.
        post_set_workspace = function(client, workspace) end,
      },

      -- Optional, configure additional syntax highlighting / extmarks.
      ui = {
        enable = true,
        update_debounce = 200,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        hl_groups = {
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },

      -- Specify how to handle attachments.
      attachments = {
        img_folder = "assets/imgs",
        img_text_func = function(client, path)
          local link_path
          local vault_relative_path = client:vault_relative_path(path)
          if vault_relative_path ~= nil then
            link_path = vault_relative_path
          else
            link_path = tostring(path)
          end
          local display_name = vim.fs.basename(link_path)
          return string.format("![%s](%s)", display_name, link_path)
        end,
      },
    })

    -- Optional, override the 'gf' keymap to utilize Obsidian's search functionality.
    vim.keymap.set("n", "gf", function()
      if require("obsidian").util.cursor_on_markdown_link() then
        return "<cmd>ObsidianFollowLink<CR>"
      else
        return "gf"
      end
    end, { noremap = false, expr = true })
  end,
}
