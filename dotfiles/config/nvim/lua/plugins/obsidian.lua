local picker_name = "telescope.nvim"

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      picker_name,
    },
    config = function(_, opts)
      -- Setup obsidian.nvim
      require("obsidian").setup(opts)

      -- Create which-key mappings for common commands.
      local wk = require "which-key"

      wk.add {
        { "<leader>o", group = "Obsidian" },
        { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open note" },
        { "<leader>od", "<cmd>ObsidianDailies -10 0<cr>", desc = "Daily notes" },
        { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image" },
        { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch" },
        { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search" },
        { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Tags" },
        { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Links" },
        { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
        { "<leader>om", "<cmd>ObsidianTemplate<cr>", desc = "Template" },
        { "<leader>on", "<cmd>ObsidianQuickSwitch nav<cr>", desc = "Nav" },
        { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename" },
        { "<leader>oc", "<cmd>ObsidianTOC<cr>", desc = "Contents (TOC)" },
        {
          "<leader>ow",
          function()
            local Note = require "obsidian.note"

          "<leader>ow",
          function()
            local Note = require "obsidian.note"
            ---@type obsidian.Client
            local client = require("obsidian").get_client()
            assert(client)

            local picker = client:picker()
            if not picker then
              client.log.err "No picker configured"
              return
            end

            ---@param dt number
            ---@return obsidian.Path
            local function weekly_note_path(dt)
              return client.dir / os.date("notes/weekly/week-of-%Y-%m-%d.md", dt)
            end

            ---@param dt number
            ---@return string
            local function weekly_alias(dt)
              local alias = os.date("Week of %A %B %d, %Y", dt)
              assert(type(alias) == "string")
              return alias
            end

            local day_of_week = os.date "%A"
            assert(type(day_of_week) == "string")

            ---@type integer
            local offset_start
            if day_of_week == "Sunday" then
              offset_start = 1
            elseif day_of_week == "Monday" then
              offset_start = 0
            elseif day_of_week == "Tuesday" then
              offset_start = -1
            elseif day_of_week == "Wednesday" then
              offset_start = -2
            elseif day_of_week == "Thursday" then
              offset_start = -3
            elseif day_of_week == "Friday" then
              offset_start = -4
            else -- Saturday
              offset_start = -5
            end

            ---@type obsidian.PickerEntry[]
            local entries = {}
            for offset = offset_start, offset_start + 6 do
              local dt = os.time() + offset * 24 * 60 * 60
              local path = weekly_note_path(dt)
              local exists = path:exists()
              table.insert(entries, {
                value = path,
                display = weekly_alias(dt) .. (exists and "" or " (new)"),
                ordinal = weekly_alias(dt),
              })
            end

            picker:pick(entries, {
              prompt_title = "Weekly Notes",
              callback = function(entry)
                if entry then
                  local path = entry.value
                  local note = Note.from_file(path)
                  if note == nil then
                    note = client:create_note {
                      id = path:stem(),
                      dir = path:parent(),
                      title = entry.display:gsub(" %(new%)", ""),
                    }
                  end
                  client:open_note(note)
                end
              end,
            })
          end,
          desc = "Weekly notes",
        },
        {
          mode = { "v" },
          {
            "<leader>oe",
            function()
              local title = vim.fn.input { prompt = "Enter title (optional): " }
              vim.cmd("ObsidianExtractNote " .. title)
            end,
            desc = "Extract text into new note",
          },
          {
            "<leader>ol",
            function()
              vim.cmd "ObsidianLink"
            end,
            desc = "Link text to an existing note",
          },
          {
            "<leader>on",
            function()
              vim.cmd "ObsidianLinkNew"
            end,
            desc = "Link text to a new note",
          },
          {
            "<leader>ot",
            function()
              vim.cmd "ObsidianTags"
            end,
            desc = "Tags",
          },
        },
      }
    end,
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/notes",
        },
        {
          name = "work",
          path = "~/work-notes",
        },
      },

      picker = {
        name = picker_name,
        mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
      },

      notes_subdir = "notes",
      new_notes_location = "notes_subdir",

      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = "daily-template.md",
      },

      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d-%a",
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

      note_id_func = function(title)
        if title ~= nil then
          return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          local suffix = ""
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
          return tostring(os.time()) .. "-" .. suffix
        end
      end,

      note_path_func = function(spec)
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,

      note_frontmatter_func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },

      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },

      preferred_link_style = "wiki",

      image_name_func = function()
        local note = require("obsidian").get_client():current_note()
        if note then
          return string.format("%s-", note.id)
        else
          return string.format("%s-", os.time())
        end
      end,

      callbacks = {
        post_setup = function(client) end,
        enter_note = function(client, note)
          if note.path.stem == "nav" then
            vim.opt.wrap = false
          end
        end,
        leave_note = function(client, note)
          vim.api.nvim_buf_call(note.bufnr or 0, function()
            vim.cmd "silent w"
          end)
        end,
        pre_write_note = function(client, note) end,
        post_set_workspace = function(client, workspace) end,
      },

      ui = {
        enable = true,
        update_debounce = 800,
        max_file_length = 5000,

        callouts = {
          ["Note"] = {
            aliases = {},
            char = "",
            hl_group = "ObsidianCalloutNote",
          },
          ["Abstract"] = {
            aliases = { "Summary", "Tldr" },
            char = "",
            hl_group = "ObsidianCalloutAbstract",
          },
          ["Info"] = {
            aliases = {},
            char = "",
            hl_group = "ObsidianCalloutInfo",
          },
          ["Todo"] = {
            aliases = {},
            char = "",
            hl_group = "ObsidianCalloutTodo",
          },
          ["Tip"] = {
            aliases = { "Hint", "Important" },
            char = "󰈸",
            hl_group = "ObsidianCalloutTip",
          },
          ["Success"] = {
            aliases = { "Check", "Done" },
            char = "󰄬",
            hl_group = "ObsidianCalloutSuccess",
          },
          ["Question"] = {
            aliases = { "Help", "FAQ" },
            char = "",
            hl_group = "ObsidianCalloutQuestion",
          },
          ["Warning"] = {
            aliases = { "Caution", "Attention" },
            char = "",
            hl_group = "ObsidianCalloutWarning",
          },
          ["Failure"] = {
            aliases = { "Fail", "Missing" },
            char = "",
            hl_group = "ObsidianCalloutFailure",
          },
          ["Danger"] = {
            aliases = { "Error" },
            char = "",
            hl_group = "ObsidianCalloutDanger",
          },
          ["Bug"] = {
            aliases = {},
            char = "",
            hl_group = "ObsidianCalloutBug",
          },
          ["Example"] = {
            aliases = {},
            char = "",
            hl_group = "ObsidianCalloutExample",
          },
          ["Quote"] = {
            aliases = {},
            char = "󱆨",
            hl_group = "ObsidianCalloutQuote",
          },
        },

        checkboxes = {
          [" "] = { order = 1, char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { order = 2, char = "", hl_group = "ObsidianDone" },
          [">"] = { order = 3, char = "", hl_group = "ObsidianRightArrow" },
          ["!"] = { order = 4, char = "", hl_group = "ObsidianTilde" },
          ["~"] = { order = 5, char = "󰰱", hl_group = "ObsidianTilde" },
          ["?"] = { order = 6, char = "", hl_group = "ObsidianTilde" },
        },

        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        block_ids = { hl_group = "ObsidianBlockID" },

        hl_groups = {
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianBullet = { bold = true, fg = "#89ddff" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianBlockID = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
          -- Callout highlights
          ObsidianCalloutNote = { bg = "#1072b8" },
          ObsidianCalloutAbstract = { bg = "#d7e6fa" },
          ObsidianCalloutInfo = { bg = "#6a93e5" },
          ObsidianCalloutTodo = { bg = "#6a93e5" },
          ObsidianCalloutTip = { bg = "#d7e6fa" },
          ObsidianCalloutSuccess = { bg = "#9fc360" },
          ObsidianCalloutQuestion = { bg = "#faebd7" },
          ObsidianCalloutWarning = { bg = "#faebd7" },
          ObsidianCalloutFailure = { bg = "#ee5d5c" },
          ObsidianCalloutDanger = { bg = "#ee5d5c" },
          ObsidianCalloutBug = { bg = "#ee5d5c" },
          ObsidianCalloutExample = { bg = "#c792ea" },
          ObsidianCalloutQuote = { bg = "#E9F0FD" },
        },
      },

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
    },
  },
}
